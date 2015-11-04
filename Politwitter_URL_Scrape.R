### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### 
                                                            
                                                                #Politwitter scrape
library("rvest")
library("dplyr")

# Defining http & CSS-selectors based on "Selector-gadget"

politwitter.main = "http://politwitter.ca/directory/facebook"
css.select = "td:nth-child(8) a"
css.select2 = "td:nth-child(2) a"
css.select3 = "td:nth-child(3)"

    # Fetching facebook links
politwitter.link = read_html(politwitter.main, encoding = "UTF-8") %>%
  html_nodes(css = css.select) %>%
  html_attr(name = 'href')
    #Fetching politician names
politwitter.name = read_html(politwitter.main, encoding = "UTF-8") %>%  
  html_nodes(css = css.select2) %>%
  html_text()
    #Fetching politician parties
politwitter.party = read_html(politwitter.main, encoding= "UTF-8") %>%
  html_nodes(css = css.select3) %>%
  html_text()

  # Apparently the css-selector [td:nth-child3] also gets 11 numerics at the end - discard these to align into dataframe
politwitter.par = politwitter.party[1:825]
politwitter.df = data.frame(politwitter.link, politwitter.name, politwitter.par)
politwitter.df$politwitter.par = gsub("tory", "cons", politwitter.df$politwitter.par)

### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### ####

  ## Extracting page-name from each URL
politwitter.df$fbpage = gsub("\\http://www.facebook.com/", "", politwitter.df$politwitter.link)

    ### This doesn't work due to the fact that some FB-pages may have two or more ID's 
    ### We need to fetch the ID's of type : pages/Olivia-Chow/15535160141 = OliviaChowTO/

  # Attempting to visit each site via loop and extract "real" URL

# InTRO-step - try out on single link: 

test1.link = "http://www.facebook.com/pages/Olivia-Chow/15535160141"
css.selector.test = "nth-child(29) a"

test.link.list = read_html(test1.link, encoding = "UTF-8") %>%
  html_nodes(css = css.selector.test) %>%
  html_attr(name = 'href')

  ### ... Not yet finished








  
  
  
  


### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### 

                                                                    #HELPERS
## CSS-link:
body > table > tbody > tr:nth-child(3) > td.line-content > span:nth-child(12)
body > table > tbody > tr:nth-child(3) > td.line-content > span:nth-child(12) > span:nth-child(5)
body > table > tbody > tr:nth-child(3) > td.line-content > span:nth-child(12) > a
body > table > tbody > tr:nth-child(3) > td.line-content > span:nth-child(29) > a
#candidates > li:nth-child(43) > div.social > a:nth-child(2)
#candidates > li:nth-child(43)
#candidates > li:nth-child(43) > h2.name

body > table > tbody > tr:nth-child(421) > td.line-content > span:nth-child(5) > a
body > table > tbody > tr:nth-child(421) > td.line-content > span:nth-child(5) > a
body > table > tbody > tr:nth-child(421) > td.line-content > span:nth-child(5) > span:nth-child(3)
body > table > tbody > tr:nth-child(442) > td.line-content > span:nth-child(5) > a
body > table > tbody > tr:nth-child(442) > td.line-content > span:nth-child(5) > a
body > table > tbody > tr:nth-child(442) > td.line-content > span:nth-child(5) > a

body > div.main-section.member > div:nth-child(1) > div > aside > div > a:nth-child(1)

#modalLearn
#modal > div > div > div > div.w-col.w-col-8 > div
#modal > div > div > div > div.w-col.w-col-8
#modal > div > div > div > div.w-col.w-col-8
#modal > #modal > #modal > #modal > #modal > #modal > #modalLearn



#modalLearn
//*[@id="modalLearn"]
#modal > div > div > div > div.w-col.w-col-8 > div
#modalName



### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### #### ### ####


                                                                  #WORK IN PROGRESS

    # Step 1 ) Create function for getting URl's
scrape_page_fb = function(politwitter.link){
  fb.link = read_html(politwitter.link)
  fb.link.id = fb.link %>%
    html_nodes("link:nth-child(14)") %>% 
    html_nodes('href') %>%
    html_text()
  return(cbind(fb.link.id, fb.link))
}

  # Step 2) Loop through each page and performing above defined function i = 826
real.links.fb = list()
for(i in politwitter.link){
  print(paste("processing", i, sep = " "))
  politwitter.df$r.link[[i]] = scrape_page_fb(i)
  #wait
  Sys.sleep(1)
  cat("done!\n")
}

  ### REMOVE ENTIRE COLUMNS
politwitter.df$r.link = NULL
politwitter.df$q.link = NULL

head > link:nth-child(14)

########### Facebook static data on each candidate



## ...

library("Rfacebook")
library("readr")
library("stringr")
library("lubridate")
library("hexbin")
library("ggplot2")

token = "CAACEdEose0cBAKOZA7MtJMDLQ5CcWGBoA3lFWaydJp4PZBPZAYk5HPgRZCRPyhZBYpdwGSF0vVnbOZAlgtC43QSsBtHE4zgf82VhnIEdyRkjcLjbnPRjk5GIQqZCrhZAV64r8UGbZAZC58fHsC5CGSZBGfsWLujVttp2jEuLlKP5EUKU01o8I1YEBZBy9RuIOxqEYSCQduWjja8ukQZDZD"
page = getPage("oalghabra", token, n =10)

  
head(URLSub, 5)





