Code analyses effect of neuronal reactivations during learning reward locations
on later calcium activity in the dorsal CA1.

Code for publication: Fuchsberger, T., Clopath, C., Jarzebowski, P., Brzosko,
Z., Wang, H. and Paulsen, O., 2022. Postsynaptic burst reactivation of
hippocampal neurons enables associative plasticity of temporally discontiguous
inputs.


# Requirements:
* [R datatrace](https://github.com/przemyslawj/datatrace/) package installed.


# Running analysis code:
Matlab code takes CaImAn output data and pre-processes data, resulting in data
published [here] (https://doi.org/10.17632/km4cdcvyfs.1). R analysis code runs
analyses on the pre-processed data.

To run the R code set the working directory to the 'R' directory with the code.
Change *base_dir* in *R/traces_input.R* to reflect the parent directory
where the unzipped data is stored locally.

Order of running analysis scripts:
1. `create_place_field_df.R` - produces place field information used in the
   analysis.
2. `reactivations.Rmd` - notebook creating figures and stats.


