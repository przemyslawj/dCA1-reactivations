Analyses effect of neuronal reactivations during learning reward locations
on later calcium activity in the dorsal CA1.

Code for publication: 
Tanja Fuchsberger, Claudia Clopath, Przemyslaw Jarzebowski, Zuzanna Brzosko, Hongbing Wang, Ole Paulsen (2022) Postsynaptic burst reactivation of hippocampal neurons enables associative plasticity of temporally discontiguous inputs. eLife 11:e81071. https://doi.org/10.7554/eLife.81071

# Computational modelling
Run `Burst_DA_Fig6_and_Fig7.m` script to replicate the network weights and activity
used to generate Figures 6 and 7.

# Calcium imaging analysis
Matlab code pre-processeses CaImAn output data from the calcium imaging experiments.
CaImAn output data is published [here] (https://doi.org/10.17632/km4cdcvyfs.1). 
R analysis code generates the statistics and the figures. It runs analyses on the
pre-processed output from the Matlab code.

To run the R code set the working directory to the 'R' directory with the code.
Change *base_dir* in *R/traces_input.R* to reflect the parent directory
where the unzipped data is stored locally.


## Calcium imaging analyses requirements:
* [R datatrace](https://github.com/przemyslawj/datatrace/) package installed.

## Order of running R analysis scripts:
1. `create_place_field_df.R` - produces place field information used in the
   analysis.
2. `reactivations.Rmd` - notebook creating figures and stats.


