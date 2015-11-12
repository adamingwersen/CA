### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### ####
                                                              #LIB PARTY SITE

                                                    # Scrape ndp party site using rvest #
                                                    #####################################
# Define link & css-selectors for fetching basic info on webpage
testlib.link = "https://www.liberal.ca/mp/"
css.selector.lib = "div.social > a:nth-child(2)"
css.selector.lib2 = "h2.name"

# Use rvest to fetch from url
library("rvest")
lib.test = read_html(testlib.link, encoding = "UTF-8") %>%
  html_nodes(css = css.selector.lib) %>%
  html_attr(name = 'href')

lib2.test = read_html(testlib.link, encoding = "UTF-8") %>%
  html_nodes(css = css.selector.lib2) %>%
  html_text()

                                                  # Cleaning, manipulation / preparation #
                                                  ########################################
libface.df = data.frame(lib2.test, lib.test) # Data.frame
# Remove https
libface.df$reallink = gsub("\\https://www.facebook.com/", "", libface.df$lib.test)
libface.df$reallink = gsub("\\?.*$", "", libface.df$reallink) # Remove any ?'s from string


# Clean all unqualified, i.e. link contains : ".numeric", "/pages/" or BlANK / NA
# Unqualified : links that are not structurally viable as feed into getPage-fct.
libface.df = libface.df[-grep("\\%", libface.df$reallink),]
libface.df = libface.df[-grep(" ", libface.df$reallink),]
libface.df$reallink = gsub("\\-", ".", libface.df$reallink)
libface.df = libface.df[-grep("\\.[1-9]", libface.df$reallink),]
libface.df = libface.df[-grep("\\pages", libface.df$lib.test),]
libface.df = libface.df[-grep("\\http:", libface.df$reallink),]
libface.df = libface.df[grep("\\[1-9]|[A-z]", libface.df$reallink),]

# Invalid pages : 404's, IP/Country-restrictions, !pages -> individuals/persons
libface.df = libface.df[-grep("\\SeanCaseyCharlottetownMP", libface.df$reallink),]
libface.df = libface.df[-grep("\\PeterFonsecaMississauga", libface.df$reallink),]
libface.df = libface.df[-grep("\\geoffreganmp", libface.df$reallink),]
libface.df = libface.df[-grep("\\Kamal.Khera.Lib", libface.df$reallink),]
libface.df = libface.df[-grep("\\yvonnejonesliberal", libface.df$reallink),]
libface.df = libface.df[-grep("\\lebouthillierd", libface.df$reallink),]
libface.df = libface.df[-grep("bryanmaycambridge", libface.df$reallink),]
libface.df = libface.df[-grep("sherryromanado", libface.df$reallink),]
libface.df = libface.df[-grep("terrysheehanformp2015", libface.df$reallink),]
libface.df = libface.df[-grep("MPScottSimms", libface.df$reallink),]
libface.df = libface.df[-grep("borysw", libface.df$reallink),]
libface.df = libface.df[-grep("PamDamoffOakvilleNorthBurlington", libface.df$reallink),]
libface.df = libface.df[-grep("lloyd4guelph", libface.df$reallink),]
libface.df = libface.df[-grep("remi.massePLC", libface.df$reallink),]
libface.df = libface.df[-grep("davidmcguinty", libface.df$reallink),]
libface.df = libface.df[-grep("VoteMonsef", libface.df$reallink),]
libface.df = libface.df[-grep("nominatejennifer", libface.df$reallink),]
libface.df = libface.df[-grep("denisparadisbromemissisquoi/", libface.df$reallink),]
libface.df = libface.df[-grep("votekateyoung", libface.df$reallink),]

# Create vector of reallink only
URLSub = libface.df[ ,'reallink'] 
NameSub = libface.df[ ,'lib2.test']
# Quotes around text
message(dQuote(URLSub))

                                                  # Facebook-request & loop using plyr #
                                                  ######################################
# Load Facebook oauth into environment:
load("fb_oauth")
token = "CAACEdEose0cBADnqZALd8JE8QsOuoAeep7fkw5fvr05FqzQy74jV5KlSBlFJNFNXQLjZCGws9a71aprBZCZCbHNR6weBMKVMiUtcQaL7BcYi2YLkOgvUmgZCR8isf0WpWYR4q1gUNWocJa1U7VRhdsXC0GkEEdQfgyc7AOhTPHteSI9LgNFk0Ij4gP8q41QZCkgCsyo9r0MgZDZD"

# Get posts from each element in URLSub (up to 10k) from 1st of july until 19th of october (2015)
require("Rfacebook")
scrapelib_fb = function(URLSub){
  fbsh = getPage(URLSub, token, n = 100000, since = '2015/07/01', until = '2015/10/19')
  return(cbind(URLSub, fbsh))
}

options(warn=1)
fb.list.liberal = list()
for(i in URLSub){
  print(paste("processing", i, sep = " :: "))
  fb.list.liberal[[i]] = scrapelib_fb(i)
  Sys.sleep(0.05)
  cat("done!\n")
}
# Iterate through all elements and apply function
library("plyr")
fb.liberal.df = data.frame(ldply(URLSub, scrapelib_fb, .inform = TRUE))
