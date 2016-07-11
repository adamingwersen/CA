### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### 
                                                              #CONS PARTY SITE
library("rvest")
library("plyr")
library("stringr")

                              # Initial scrape of all MP's in Canadian parliament from wikipedia #
                              ####################################################################
# Link & css-selectors
wikipedia.link = "https://en.wikipedia.org/wiki/List_of_House_members_of_the_42nd_Parliament_of_Canada"
css.con.party = "td:nth-child(2) a"
css.con.name = "td:nth-child(3)"
# Get page
cons.name = read_html(wikipedia.link, encoding = "UTF-8") %>%
    html_nodes(css = css.con.name) %>%
    html_text()
cons.party = read_html(wikipedia.link, encoding = "UTF-8") %>%
    html_nodes(css = css.con.party) %>%
    html_text()
# Delete wikipedia header - first 3 elements in list in order to have list of same lenght for bind
cons.party = cons.party[-c(1:3)]
# Coerce intro dataframe and 'grep' only Conservatives
cons.wiki = data.frame(c(cons.party), c(cons.name))
cons.wiki = cons.wiki[grep("\\Conservative", cons.wiki$c.cons.name),]

# Separate names - names of length 2+ will be taken care of later
cons.wiki$fname = word(cons.wiki$c.cons.party., +1)
cons.wiki$lname = word(cons.wiki$c.cons.party., -1)
# The link-type:
cons.wiki$link = "http://www.conservative.ca/team/member/?fname=LANK&lname=LAKN&type=mps"
# Define vectors of each name
fname = cons.wiki$fname
lname = cons.wiki$lname
# .
c.wiki.list = cons.wiki$link[1]
# 
# Solution - the other approach was really tedious. I did not succeed with functional apprach because R multiplies vectors by nxn, not 1xn
write.table(cons.intro, "wd", sep = "\t")

# Import manually modified .csv-file from github
cons.link.df = read.csv("https://raw.githubusercontent.com/adamingwersen/CA/master/ConsLearn.csv", header= FALSE, sep = ";")
# Remove candidates whose external conservative.ca/-page promps error: 404
cons.link.df = cons.link.df[-grep("Erin O'Toole", cons.link.df$V1),]
cons.link.df = cons.link.df[-grep("Dave MacKenzie", cons.link.df$V1),]
cons.link.df = cons.link.df[-grep("Peter Van Loan", cons.link.df$V1),]
# Reformat to vector for smooth looping..
cons.link.li = list(cons.link.df$V2)
cons.link.li = unlist(cons.link.df$V2)


                                        # Crawler for .conservative.ca/...; fct., loop & clean #
                                        ########################################################

# Relevant css.selector for facebook 'href'
css.selector.fb_page = ".aside-meta-block:nth-child(1)"
# Function : fetch info -> cbind
require("rvest")
scrape_fb_con = function(cons.link.li) {
  fb.get.con = read_html(cons.link.li, encoding = "UTF-8") %>%
    html_nodes(css = css.selector.fb_page) %>%
    html_attr(name = 'href')
  return(cbind(fb.get.con))
}

# Loop : run requests -> sleep -> repeat
page.link.df = list()
for(i in cons.link.li){
  print(paste("processing", i, sep = " "))
  page.link.df[[i]] = scrape_fb_con(i)
  Sys.sleep(0.05)
  cat("done\n")
}
# Transformations
trans1.con = ldply(page.link.df, data.frame)

                                         # Page/politician post history using Rfacebook/FB API #
                                         #######################################################

# The API for R is not calibrated to evaluate actual URL's, however pagename = URL-end
# https://www.facebook.com/Amazon should be fed into getPage() as "Amazon"
facebook.links.tr = gsub("\\https://www.facebook.com/", "",  trans1.con$fb.get.con)   # Remove string of type 1
facebook.links.tr2 = gsub("\\http://facebook.com/", "",  facebook.links.tr)         # Remove string of type 2
facebook.links.tr3 = gsub("pmharper", "RtHonStephenHarper/",  facebook.links.tr2)   # Stephen Harper has changed - conservative.ca is out-of-date
facebook.links.tr3 = facebook.links.tr3[!duplicated(facebook.links.tr)]             # Remove any duplicates

# API-request preparation : 
    ## Re-install "Rfacebook" as CRAN-R delivers different version that authors github-page..
library("devtools")
install_github("pablobarbera/Rfacebook/Rfacebook")
library("Rfacebook")
    ## Create oauth in order to avoid having to fetch token every 2nd hr manually
library("httr")
fb_oauth <- fbOAuth(app_id = "XXX", app_secret = "XXX", extended_permissions = FALSE)
save(fb_oauth, file = "fb_oauth")
    ## Load oauth-key/token
load("fb_oauth")

# Function that defines span, target and token <- oauth
get_fb_cons = function(facebook.links.tr3){
  fb.feed.con = getPage(facebook.links.tr3, token=fb_oauth, n = 100000, since = '2015/07/01', until = '2015/10/19')
  return(cbind(fb.feed.con, facebook.links.tr3))
}

# Two types of loops:
    ## 'plyr' is simple
fb.con.list = ldply(facebook.links.tr3, get_fb_cons, .inform = TRUE)
    ## custom is faster and lets you display errors in a nicer way
options(warn=1)
fb.list.conservative = list()
for(i in facebook.links.tr3){
  print(paste("processing", i, sep = " :: "))
  fb.list.conservative[[i]] = get_fb_cons(i)
  Sys.sleep(0.05)
  cat("done!\n")
}

# Coerce fb.list.conservative into ONE large dataframe : 
facebook.conservative.df = ldply(fb.list.conservative, data.frame)
