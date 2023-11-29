
# load source 
source("_config/config.R")

# load data
df <- fread("data/data.csv")

# check gender, race ratio 
table(df$gender) # 62% Male, 38% Female
table(df$race)  # 67% W, 13% B, 20% Other

# reweight gender to ratio
# 0: 49% Male, 1: 51% Female 
# reweight race to ratio
# 1: 64% White, 2: 12% Black, 3: 24% Other

#-------- produce weights 

df_unweighted <- 
  svydesign(ids = ~1, data = df)

# define wanted gender distribution
gender.dist <- 
  data.frame(gender = c(0,1), 
           Freq = nrow(df)*c(.49,.51))

# define wanted race distribution
race.dist  <- 
  data.frame(race=c(1,2,3), 
             Freq=nrow(df)*c(.64,.12,.24))

# rake 
df_rake <- 
  rake(design = df_unweighted,
       # sample distri
       sample.margins <- list(~gender,~race),
       # pop distri
       population.margins <- 
         list(gender.dist, race.dist))

# trim weights 
df_rake_trim <- 
  trimWeights(df_rake, 
              lower=.3, 
              upper=3, 
              strict=TRUE)

# add var: weights
df$weights <- weights(df_rake)
head(df$weights)

# add var: weights_trim
df$weights_trim  <- 
  weights(df_rake_trim)
head(df$weights_trim)

# check the list of weights used:
stack(table(df$weights))

# check the list of trimmed weights used:
stack(table(df$weights_trim))

# check gender ratio after apply weights
# same as pop ratio 
svytable(~gender, 
         df_rake_trim)

# check race ratio after apply weights
# same as pop ratio 
svytable(~race, 
         df_rake_trim)

# save data with weights 
fwrite(df, 
       "cache/data_weights.csv",
       row.names = F)

