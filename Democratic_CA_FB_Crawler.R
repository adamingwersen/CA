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

ndp.candidate.profile.list = data.frame(ndp.candidate.profile.list, ndp.link)

ndp.candidate.profile.list = ndp.candidate.profile.list[-grep("Carol Hughes", ndp.candidate.profile.list$ndp.name),]
ndp.candidate.profile.list = ndp.candidate.profile.list[-grep("Anne Minh-Thu Quach", ndp.candidate.profile.list$ndp.name),]
ndp.candidate.profile.list = ndp.candidate.profile.list[-grep("Charlie Angus", ndp.candidate.profile.list$ndp.name),]
ndp.candidate.profile.list = ndp.candidate.profile.list[-grep("FranÃ§ois Choquette", ndp.candidate.profile.list$ndp.name),]
ndp.candidate.profile.list = ndp.candidate.profile.list[-grep("Brian Masse", ndp.candidate.profile.list$ndp.name),] 
# Match names with links
ndp.candidate.complete.frame = ndp.candidate.profile.list
# Remove candidates with invalid facebook pages

# String manipulation - I only want input for: Rfacebook -> getPage()
library("stringr")
ndp.candidate.complete.frame$fbref = gsub("\\https://fb.com/", "", ndp.candidate.complete.frame$ndp.link)
# List of FB ext's
fbref.sub = ndp.candidate.complete.frame[ ,'fbref']
# Put into quotes..
message(dQuote(fbref.sub))
                                                      # Gathering FB posts using plyr loop #
                                                      ######################################
# Load Facebook oauth into environment:
load("fb_oauth")
token = "CAACEdEose0cBAEnDPZAO3sy82AffdfesZCI7ZBsiWQNGnTN5CGu7okvJR4PF7ri7tTLL2CDjp0QDkDcL4pUZAV8hl8AZCfmX0cloGaVQpjIS9ZCayiixUzZBsaAviyZCIcD7saImoc11GfPAOkS1qOnhecO25O5ebl3ZCL1U7yIO3QWXD9LtpZArxm9Ui77iZCSloDBbxuATgIBQgZDZD"

# Facebook request-function using getPage 
library("Rfacebook")
library("httr")
library("rjson")
library("httpuv")
scrape_ndp_fb = function(fbref.sub){
  fbndp = getPage(fbref.sub, token, n = 9999, since = '2015/07/01', until = '2015/10/19')
  return(cbind(fbndp, fbref.sub))
}

fb.democratic.list = list()
for(i in fbref.sub){
  print(paste("processing", i, sep = " :: "))
  fb.democratic.list[[i]] = scrape_ndp_fb(i)
  Sys.sleep(0.5)
  cat("done!\n")
}

fb.democratic.df  = ldply(fb.democratic.list, data.frame)

# Simple looping with HW's plyr-package - .inform = TRUE -> if error; show content
library("plyr")
plyrndp = data.frame(ldply(fbref.sub, scrape_ndp_fb, .inform = TRUE))

