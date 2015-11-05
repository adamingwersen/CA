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

# Create vector of reallink only
URLSub = libface.df[ ,'reallink'] 
NameSub = libface.df[ ,'lib2.test']
# Quotes around text
message(dQuote(URLSub))

                                                  # Facebook-request & loop using plyr #
                                                  ######################################
# Load Facebook oauth into environment:
load("fb_oauth")

# Get posts from each element in URLSub (up to 10k) from 1st of july until 19th of october (2015)
require("Rfacebook")
scrapelib_fb = function(URLSub){
  fbsh = getPage(URLSub, token = fb_oauth, n = 10000 since = '2015/07/01', until = '2015/10/19')
  if(class(fbsh)=='try-error') next;
  return(fbsh)
}
# Iterate through all elements and apply function
library("plyr")
dplr = data.frame(ldply(URLSub, scrapelib_fb, .inform = TRUE))