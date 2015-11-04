### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### ####

#LIB PARTY SITE

testlib.link = "https://www.liberal.ca/mp/"
css.selector.lib = "div.social > a:nth-child(2)"
css.selector.lib2 = "h2.name"

lib.test = read_html(testlib.link, encoding = "UTF-8") %>%
  html_nodes(css = css.selector.lib) %>%
  html_attr(name = 'href')

lib2.test = read_html(testlib.link, encoding = "UTF-8") %>%
  html_nodes(css = css.selector.lib2) %>%
  html_text()
  
    ## Data Cleaning

head(politwitter.df$politwitter.link, 1)

libface.df = data.frame(lib2.test, lib.test)

libface.df$reallink = gsub("\\https://www.facebook.com/", "", libface.df$lib.test)
libface.df$reallink = gsub("\\?.*$", "", libface.df$reallink)

# pages/ - fix, however the pages is still an issue due to wierd code at the end. 
libface.df$reallink = gsub("\\pages/", "", libface.df$reallink)
libface.df$reallink = gsub("\\/.*$", "", libface.df$reallink)

### Clean all unqualified, i.e. link contains : ".numeric", "/pages/" or BlANK / NA

libface.df = libface.df[-grep("\\%", libface.df$reallink),]
libface.df = libface.df[-grep(" ", libface.df$reallink),]
libface.df$reallink = gsub("\\-", ".", libface.df$reallink)
libface.df = libface.df[-grep("\\.[1-9]", libface.df$reallink),]
libface.df = libface.df[-grep("\\pages", libface.df$lib.test),]
libface.df = libface.df[-grep("\\http:", libface.df$reallink),]
libface.df = libface.df[grep("\\[1-9]|[A-z]", libface.df$reallink),]

### Extra exceptions by looping:
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

head(URLSub, 10)

# PLYR LOOP

library("plyr")
dplr = data.frame(ldply(URLSub, scrapelib_fb, .inform = TRUE))

      ### FACEBOOK FUNCTION

token = "CAACEdEose0cBAPeZAkDZBbVLpMp75lctnChr6uXImNuwv7jRjKcKGn0X891oWdm2368Sf9P8cv7KcUNSN7tRQeZCU9Jz4lN2mj3ZBRDMqExXk2E0Dauus3130iCuzVWF7NhQteFQMdCHlZBM1X29CZAKvslQg73YUk8sYWhCe5XDKUdabKFceQZAI6R0Qer5DGUVXWjwStUZCQZDZD"


require("Rfacebook")
scrapelib_fb = function(URLSub){
  fbsh = getPage(URLSub, token, n = 2)
  if(class(fbsh)=='try-error') next;
  return(fbsh)
  }

### MISC

head(URLSub[105])

URLSUBUNO = scrapelib_fb(URLSub[13])

URLSub[13]



post.lib.hist = data.frame() {
  for(i in URLSub){
    print(paste("processing", i, sep = " "))
    post.lib.hist[[i]] = scrapelib_fb(i)
    assign(paste0("post.lib.hist", i), i)
    #wait
    Sys.sleep(1)
    cat("done!\n")
  }


write.table(libface.df, "wd", sep = "\t")
