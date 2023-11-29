# # install packages 
# devtools::install_github("mcanigueral/evprof") # https://github.com/mcanigueral/evprof/
# devtools::install_github("mcanigueral/evsim") # https://github.com/mcanigueral/evsim

# "dygraphs" sample code 
# https://rstudio.github.io/dygraphs/gallery-series-options.html

# evprof examples
# https://mcanigueral.github.io/evprof/reference/get_ev_model.html#ref-examples

# load packages 
source("_config/config.R")


##################
###  EV model  ###
##################

# EV model with California ACN data 
ev_model <- california_ev_model

# check model 
print(ev_model)

# workday_models
workday_models <- ev_model$models$user_profiles[[1]]

# check 
data.table(workday_models)

# weekend_models
weekend_models <- ev_model$models$user_profiles[[2]]

# check 
data.table(weekend_models)

# number of sessions per day 
sessions_per_day <- tibble(
  time_cycle = ev_model$models$time_cycle,
  n_sessions = c(150, 50)
)

# check
data.table(sessions_per_day)

# create user_profiles
user_profiles <- tibble(
  time_cycle = c('Workday', 'Workday', 'Weekend'),
  profile = c('Visit', 'Worktime', 'Visit'),
  ratio = c(0.2, 0.8, 1),
  power = c(NA, 11, NA)
)

# check
user_profiles

# Visit profile energy models
data.table(workday_models$energy_models[[1]])

# charging_powers
charging_powers <- tibble(
  power = c(3.7, 7.3, 11),
  ratio = c(0.2, 0.4, 0.4))

# check
charging_powers

# dates_sim
dates_sim <- seq.Date(from = as.Date('2019-09-10'), to = as.Date('2019-09-15'), by = '1 day')

# check
dates_sim

#-------------Simulate a new session 
sessions_estimated <- simulate_sessions(
  ev_model,
  sessions_per_day, 
  user_profiles,
  charging_powers,
  dates_sim,
  resolution = 15 # every 15min
)

# check simulation results 
data.table(head(sessions_estimated))

# 700 sessions 
dim(sessions_estimated)

# check # of sessions of each power rate corresponds to our configuration
sessions_estimated %>% 
  group_by(Profile, Power) %>% 
  summarise(n = n()) %>% 
  mutate(pct = n/sum(n)*100)

#--------------- Estimate EV demand

# generate date time sequence
dttm_seq <- seq.POSIXt(
  from = as.POSIXct('2019-09-10'), 
  to = as.POSIXct('2019-09-16'), 
  by = '15 min'
) %>% 
  lubridate::with_tz(
    ev_model$metadata$tzone
  )

# estimate EV demand 
estimated_demand <- 
  sessions_estimated %>% 
  get_demand(dttm_seq)

# convert to data frame 
estimated_demand <- data.frame(estimated_demand)

# convert to times series
estimated_demand_xts <- xts(estimated_demand[, -1], 
 order.by=estimated_demand[,1])

# check 
data.table(estimated_demand)

# plot 
p_demand <- dygraph(estimated_demand_xts,
        main = "Estimated EV Demand",
        xlab = "",
        ylab = "") %>%
  dyOptions(fillGraph = TRUE,
            fillAlpha = 0.4)

# show plot 
p_demand

# save plot 
save_html(p_demand, 
          file = "figure/EV_demand.html")
