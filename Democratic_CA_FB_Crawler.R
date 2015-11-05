### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### 
                                                            #NDP PARTY SITE

                                                    # Scrape ndp party site using rvest #
                                                    #####################################
library("rvest")
# Defining css-selectors for ndp.ca/team
testndp.link = "http://www.ndp.ca/team"
css.selector.ndp3 = "a.candidate-facebook"
css.selector.ndpname = "strong"
css.selector.province = "span.candidate-prov-abbrev"

# Get relevant information from site using rvest
ndp.link = read_html(testndp.link, encoding = "UTF-8") %>%
  html_nodes(css = css.selector.ndp3) %>%
  html_attr(name = 'href')
ndp.name = read_html(testndp.link, encoding = "UTF-8") %>%
  html_nodes(css = css.selector.ndpname) %>%
  html_text()
ndp.province = read_html(testndp.link, encoding = "UTF-8") %>%
  html_nodes(css = css.selector.province) %>%
  html_text()
# Coerce into data.frame
ndp.candidate.profile.list = data.frame(ndp.name, ndp.province)

                                                    # Cleaning, manipulation / preparation #
                                                    ########################################
# Remove 404's
ndp.candidate.profile.list = ndp.candidate.profile.list[-grep("Daniel Blaikie", ndp.candidate.profile.list$ndp.name),]
ndp.candidate.profile.list = ndp.candidate.profile.list[-grep("Karine Trudel", ndp.candidate.profile.list$ndp.name),]
ndp.candidate.profile.list = ndp.candidate.profile.list[-grep("Gord Johns", ndp.candidate.profile.list$ndp.name),]
# Match names with links
ndp.candidate.complete.frame = data.frame(ndp.candidate.profile.list, ndp.link)
# Remove candidates with invalid facebook pages
ndp.candidate.complete.frame = ndp.candidate.complete.frame[-grep("Carol Hughes", ndp.candidate.complete.frame$ndp.name),]
ndp.candidate.complete.frame = ndp.candidate.complete.frame[-grep("Anne Minh-Thu Quach", ndp.candidate.complete.frame$ndp.name),]
ndp.candidate.complete.frame = ndp.candidate.complete.frame[-grep("charlie.angus.58", ndp.candidate.complete.frame$fbref),]
ndp.candidate.complete.frame = ndp.candidate.complete.frame[-grep("FrancoisChoquette.deputeDrummond", ndp.candidate.complete.frame$fbref),]
ndp.candidate.complete.frame = ndp.candidate.complete.frame[-grep("brianmassemp", ndp.candidate.complete.frame$fbref),] 

# String manipulation - I only want input for: Rfacebook -> getPage()
library("stringr")
ndp.candidate.complete.frame$fbref = gsub("\\https://fb.com/", "", ndp.candidate.complete.frame$ndp.link)
# List of FB ext's
fbref.sub = ndp.candidate.complete.frame[ ,'fbref']
# Put into quotes..
message(dQuote(fbref.sub))

                                                      # Gathering FB posts using plyr loop #
                                                      ######################################

# Facebook request-function using getPage 
library("Rfacebook")
scrape_ndp_fb = function(fbref.sub){
  fbndp = getPage(fbref.sub, token = fb_oauth, n = 10000, since = '2015/07/01', until = '2015/10/19')
  if(class(fbndp)=='try-error') next;
  return(fbndp)
}

# Simple looping with HW's plyr-package - .inform = TRUE -> if error; show content
library("plyr")
plyrndp = data.frame(ldply(fbref.sub, scrapendp_fb, .inform = TRUE))




