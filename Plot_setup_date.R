## 
library("readr")
library("lubridate")
library("stringr")
?str_split
date.dem = fb.democratic.df
date.dem$created_time = parse_datetime(date.dem$created_time)   # Parse ISO 8061 format
date.dem$date = word(date.dem$created_time, +1)                 # Split date
date.dem$time = word(date.dem$created_time, -1)                 # Split time
date.dem$party = "NDP"

date.lib = fb.liberal.df
date.lib$created_time = parse_datetime(date.lib$created_time)
date.lib$date = word(date.lib$created_time, +1)
date.lib$time = word(date.lib$created_time, -1)
date.lib$party = "LIB"

date.con = facebook.conservative.df
date.con$created_time = parse_datetime(date.con$created_time)
date.con$date = word(date.con$created_time, +1)
date.con$time = word(date.con$created_time, -1)
date.con$party = "CON"


library("ggplot2")
p = ggplot(date.con, aes(x = as.Date(date), y = likes_count))
p = p + geom_line()
plot(p)

p = ggplot(date.con, aes(x = as.Date(date), y = comments_count))
p = p + geom_line()
plot(p)

p = ggplot(date.con, aes(x = as.Date(date), y = shares_count, fill = from_name))
p = p + geom_bar(stat = "identity")
plot(p)

p = ggplot(date.con, aes(x = as.Date(date), y = likes_count, fill = from_name))
p = p + geom_bar(stat = "identity")
plot(p)

p = ggplot(date.con, aes(x = as.Date(date), y = comments_count, fill = from_name))
p = p + geom_bar(stat = "identity")
plot(p)

library("dplyr")
combi.df = full_join(date.con, date.lib)
combi.df = full_join(combi.df, date.dem)

p = ggplot(combi.df, aes(x = as.Date(date), y = likes_count, colour = party, group = party))
p = p + geom_line() + geom_smooth() + facet_wrap(~type)
plot(p)

p = ggplot(combi.df, aes(x = as.Date(date), y = likes_count, colour = party, group = party))
p = p + geom_line() + geom_smooth() + facet_wrap(~type)
plot(p)

p = ggplot(combi.df, aes(x = as.Date(date), y = shares_count, fill = .id))
p = p + geom_line() + facet_wrap(~party)
plot(p)








  