### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### 
    #NDP PARTY SITE
testndp.link = "http://www.ndp.ca/team"
css.selector.ndp3 = "a.candidate-facebook"
css.selector.ndpname = "strong"
css.selector.province = "span.candidate-prov-abbrev"


ndp.link = read_html(testndp.link, encoding = "UTF-8") %>%
  html_nodes(css = css.selector.ndp3) %>%
  html_attr(name = 'href')
ndp.name = read_html(testndp.link, encoding = "UTF-8") %>%
  html_nodes(css = css.selector.ndpname) %>%
  html_text()
ndp.province = read_html(testndp.link, encoding = "UTF-8") %>%
  html_nodes(css = css.selector.province) %>%
  html_text()


ndp.candidate.profile.list = data.frame(ndp.name, ndp.province)

ndp.candidate.profile.list = ndp.candidate.profile.list[-grep("Daniel Blaikie", ndp.candidate.profile.list$ndp.name),]
ndp.candidate.profile.list = ndp.candidate.profile.list[-grep("Karine Trudel", ndp.candidate.profile.list$ndp.name),]
ndp.candidate.profile.list = ndp.candidate.profile.list[-grep("Gord Johns", ndp.candidate.profile.list$ndp.name),]


ndp.candidate.complete.frame = data.frame(ndp.candidate.profile.list, ndp.link)

ndp.candidate.complete.frame = ndp.candidate.complete.frame[-grep("Carol Hughes", ndp.candidate.complete.frame$ndp.name),]
ndp.candidate.complete.frame = ndp.candidate.complete.frame[-grep("Anne Minh-Thu Quach", ndp.candidate.complete.frame$ndp.name),]
ndp.candidate.complete.frame = ndp.candidate.complete.frame[-grep("charlie.angus.58", ndp.candidate.complete.frame$fbref),]
ndp.candidate.complete.frame = ndp.candidate.complete.frame[-grep("FrancoisChoquette.deputeDrummond", ndp.candidate.complete.frame$fbref),]
ndp.candidate.complete.frame = ndp.candidate.complete.frame[-grep("brianmassemp", ndp.candidate.complete.frame$fbref),] 

library("stringr")
ndp.candidate.complete.frame$fbref = gsub("\\https://fb.com/", "", ndp.candidate.complete.frame$ndp.link)

fbref.sub = ndp.candidate.complete.frame[ ,'fbref']
message(dQuote(fbref.sub))


      ### Facebook request

token = "CAACEdEose0cBAHO9fVn94JDIZBWt40rx46JLHL7PrXTZBStxHbdSHp5I1EZCAJYDO80Teg21R2IYrZAZC0r8EnHCpmYzka8hqtxz9C8hGaebNDb2CNOnqpQ63nKHkhgtzlw0kbRirZBCzq70y5JFnoQY53ceKNOyg66yexsTgiuFrqwKoDdtDtGgnsmlLJE0B5ZCg3rQyKqaQZDZD"

require("Rfacebook")

    ## Request-function NDP
scrapendp_fb = function(fbref.sub){
  fbndp = getPage(fbref.sub, token, n = 2)
  if(class(fbndp)=='try-error') next;
  return(fbndp)
}

library("plyr")
plyrndp = data.frame(ldply(fbref.sub, scrapendp_fb, .inform = TRUE))




