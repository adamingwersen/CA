### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### 
#CONS PARTY SITE
library("rvest")
library("plyr")
library("stringr")


wikipedia.link = "https://en.wikipedia.org/wiki/List_of_House_members_of_the_42nd_Parliament_of_Canada"
css.con.party = "td:nth-child(2) a"
css.con.name = "td:nth-child(3)"


cons.name = read_html(wikipedia.link, encoding = "UTF-8") %>%
    html_nodes(css = css.con.name) %>%
    html_text()
cons.party = read_html(wikipedia.link, encoding = "UTF-8") %>%
    html_nodes(css = css.con.party) %>%
    html_text()

# x3
cons.party = cons.party[-c(1:3)]

cons.wiki = data.frame(c(cons.party), c(cons.name))
cons.wiki = cons.wiki[grep("\\Conservative", cons.wiki$c.cons.name),]

## FAILED 

library("stringr")
cons.wiki$fname = word(cons.wiki$c.cons.party., +1)
cons.wiki$lname = word(cons.wiki$c.cons.party., -1)
cons.wiki$link = "http://www.conservative.ca/team/member/?fname=LANK&lname=LAKN&type=mps"

fname = cons.wiki$fname
lname = cons.wiki$lname

c.wiki.list = cons.wiki$link[1]

str_fname_replace = function(fname) {
  fname.link = gsub("\\LANK", fname, c.wiki.list) %>%
    lname.link = gsub("\\LAKN", lname, c.wiki.list)
  return(c(fname.link))
}
str_lname_final = function(lname) {
  lname.link = gsub("\\LAKN", lname, cons.fname.list)
}

cons.fname.list = ldply(fname, str_fname_replace)
cons.fname.list = list(c(cons.fname.list$V1))
cons.lname.list = ldply(lname, str_lname_final)
cons.lname.list = sapply(lname, str_lname_final)

cons.intro.li = unlist(cons.intro.li)
cons.intro.li = data.frame(cons.intro.li, lname)
conservative.link.df = sapply(lname, str_link_final, simplify = FALSE)

# Solution - the other approach was really tedious. I did not succeed with functional apprach because R multiplies vectors by nxn, not 1xn
write.table(cons.intro, "wd", sep = "\t")

cons.link.df = read.csv("https://raw.githubusercontent.com/adamingwersen/CA/master/ConsLearn.csv", header= FALSE, sep = ";")
cons.link.df = cons.link.df[-grep("Erin O'Toole", cons.link.df$V1),]
cons.link.df = cons.link.df[-grep("Dave MacKenzie", cons.link.df$V1),]
cons.link.df = cons.link.df[-grep("Peter Van Loan", cons.link.df$V1),]

cons.link.li = list(cons.link.df$V2)
cons.link.li = unlist(cons.link.df$V2)

#Visit each party members .conservatve/page and fetch facebook link

body > div.main-section.member > div:nth-child(1) > div > aside > div > a:nth-child(1)

css.selector.fb_page = ".aside-meta-block:nth-child(1)"

require("rvest")
scrape_fb_con = function(cons.link.li) {
  fb.get.con = read_html(cons.link.li, encoding = "UTF-8") %>%
    html_nodes(css = css.selector.fb_page) %>%
    html_attr(name = 'href')
  return(cbind(fb.get.con))
}

page.link.df = list()
for(i in cons.link.li){
  print(paste("processing", i, sep = " "))
  page.link.df[[i]] = scrape_fb_con(i)
  Sys.sleep(0.05)
  cat("done\n")
}

trans1.con= data.frame(page.link.df)
trans2.con = t(trans1.con)
facebook.links.cons = as.list(trans2.con)
facebook.links.cons = unlist(facebook.links.cons)

## FACEBOOK

### Cleaning

library("stringr")
facebook.links.tr = gsub("\\https://www.facebook.com/", "",  facebook.links.cons)
facebook.links.tr2 = gsub("\\http://facebook.com/", "",  facebook.links.tr)
head(facebook.links.tr2, 5)

facebook.links.tr3 = facebook.links.tr2[-6]
facebook.links.tr3 = facebook.links.tr3[-9]
facebook.links.tr3 = facebook.links.tr3[-30]
#x2
facebook.links.tr3 = facebook.links.tr3[-31]
#x2
facebook.links.tr3 = facebook.links.tr3[-36]
facebook.links.tr3 = facebook.links.tr3[-38]
facebook.links.tr3 = facebook.links.tr3[-51]
facebook.links.tr3 = facebook.links.tr3[-53]
facebook.links.tr3 = facebook.links.tr3[-62]
facebook.links.tr3 = facebook.links.tr3[-76]
#x2
facebook.links.tr3 = facebook.links.tr3[-81]

### API-request
token <- "CAACEdEose0cBAPsMJ09RC7yDkmrGOA9E8d6fdlYjvW9Qoh6lucZCFjw1Y6KUHalpkwI6fZC4QDrtTbU4RjO3uqE71QJiiC1ewJPn1spATUrlvWnmMDGIXvm6hYP2ou3GiZBgaPkd3mZBDZAf0gAaXMgYSJ5f1nY6gZBVCegoCIyUbw0c5qk72n8dbfvb0K5AJ5zSvTIoca9gZDZD"
require("Rfacebook")
get_fb_cons = function(facebook.links.tr3){
  fb.feed.con = getPage(facebook.links.tr3, token, n = 10)
  return(cbind(fb.feed.con, facebook.links.tr3))
}

library("plyr")
fb.con.list = ldply(facebook.links.tr3, get_fb_cons, .inform = TRUE)











