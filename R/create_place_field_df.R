library(dplyr)
library(plyr)
library(pracma)
library(readr)
library(tidyr)
library(stringr)

library(DT)
library(data.table)
library(tictoc)
library(pryr) # for memory checks
library(datatrace)

setwd("~/mnt_code/cheeseboard_analysis/R")


summarise = dplyr::summarise
summarize = dplyr::summarize

source('locations.R')
source('place_field_utils.R')
source('plotting_params.R')
source('traces_input.R')
source('utils.R')

nbins = 20
timebin.dur.msec = 200
min.occupancy.sec = 1.0
trace.var = 'smoothed_deconv_trace'
gen_imgs_dir = '~/tmp/pcs/'

run.trials.si = data.frame()
early.trials.si = data.frame()
late.trials.si = data.frame()

run.fields = list()
run.occupancies = list()
early.fields = list()
early.occupancies = list()
late.fields = list()
late.occupancies = list()


add.meta.cols = function(df, animal, date) {
  df$animal = as.factor(rep(animal, nrow(df)))
  df$date = as.factor(rep(date, nrow(df)))
  return(df)
}

trials.meta.df = read.trials.meta(rootdirs)
mouse.meta.df = read.mouse.meta(rootdirs)

test.days.df.joined = bind_rows(
  test.days.df %>% mutate(day_ordinal_name='first'),
  #last.days.df %>% mutate(day_ordinal_name='last')
) %>%
  left_join(trials.meta.df, by=c('animal', 'date')) %>%
  left_join(mouse.meta.df) %>%
  filter(implant == 'dCA1') %>%
  filter(day_desc != 'learning3 day#3', day_desc != 'learning4 day#3') # Ignore days when only 4 trials performed


for (i in 1:nrow(test.days.df.joined)) {
  caimg_result_dir = find.caimg.dir(caimg_result_dirs, test.days.df.joined$animal[i], test.days.df.joined$date[i])
  tic("reading and preprocessing traces")
  data.traces = read.data.trace(caimg_result_dir)
  data.traces$date = rep(char2date(data.traces$date[1]), nrow(data.traces))
  date = data.traces$date[1]
  animal = data.traces$animal[1]

  binned.traces.run = prepare.run.dirtraces(data.traces, nbins)
  toc()

  plot.dir.prefix = paste(gen_imgs_dir, animal, format(date), sep='/')


  tic("spatial info on all trials running")
  run.spatial = calc.spatial.info(binned.traces.run[exp_title == 'trial'],
                                  plot.dir=paste0(plot.dir.prefix, '/run/'),
                                  generate.plots=FALSE,
                                  nshuffles=1000,
                                  timebin.dur.msec=timebin.dur.msec,
                                  shuffle.shift.sec = 10,
                                  trace.var=trace.var,
                                  nbins=nbins,
                                  min.occupancy.sec=min.occupancy.sec,
                                  gaussian.var = 2)
  run.trials.si = bind_rows(run.trials.si, add.meta.cols(run.spatial$df, animal, date))
  run.fields[[animal]][[format(date)]] = run.spatial$field
  run.occupancies[[animal]][[format(date)]] = run.spatial$occupancy
  toc()

   # Early vs late
  half.trial = ceiling(max(data.traces$trial) / 2)
  tic("spatial info on early trials")
  early.spatial = calc.spatial.info(binned.traces.run[exp_title == 'trial' & trial <= half.trial,],
                                    paste0(plot.dir.prefix, '/early/'),
                                    nshuffles=0,
                                    trace.var=trace.var,
                                    timebin.dur.msec=timebin.dur.msec,
                                    nbins=nbins,
                                    min.occupancy.sec=min.occupancy.sec,
                                    gaussian.var = 2)
  early.trials.si = bind_rows(early.trials.si, add.meta.cols(early.spatial$df, animal, date))
  early.fields[[animal]][[format(date)]] = early.spatial$field
  early.occupancies[[animal]][[format(date)]] = early.spatial$occupancy
  toc()

  tic("spatial info on late trials")
  late.spatial = calc.spatial.info(binned.traces.run[exp_title == 'trial' & trial > half.trial, ],
                                   paste0(plot.dir.prefix, '/late/'),
                                   nshuffles=0,
                                   timebin.dur.msec=timebin.dur.msec,
                                   trace.var=trace.var,
                                   nbins=nbins,
                                   min.occupancy.sec=min.occupancy.sec,
                                   gaussian.var = 2)
  late.trials.si = bind_rows(late.trials.si, add.meta.cols(late.spatial$df, animal, date))
  late.fields[[animal]][[format(date)]] = late.spatial$field
  late.occupancies[[animal]][[format(date)]] = late.spatial$occupancy
  toc()

  print('Memory used')
  print(mem_used())
}


print("Saving env variables")
save.image(file="data/pc.RData")

