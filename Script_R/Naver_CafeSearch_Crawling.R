library(stringr)
library(rvest)
library(RSelenium)

urlSearch <- "https://section.cafe.naver.com/cafe-home/search/articles?query=%EC%A7%80%EC%BD%94%20%EA%B0%80%EB%94%94%EA%B1%B4#%7B%22query%22%3A%22%EC%A7%80%EC%BD%94%20%EA%B0%80%EB%94%94%EA%B1%B4%22%2C%22page%22%3A1%2C%22sortBy%22%3A0%2C%22period%22%3A%5B%222003.12.01%22%2C%222019.01.07%22%5D%2C%22menuType%22%3A%5B0%5D%2C%22searchBy%22%3A0%2C%22duplicate%22%3Afalse%2C%22includeAll%22%3A%22%22%2C%22exclude%22%3A%22%22%2C%22include%22%3A%22%22%2C%22exact%22%3A%22%22%7D"

dateProcessing <- function(cafeDate){
  cafeDate <- gsub("판매","",cafeDate) #판매 글자 제거 
  cafeDate <- gsub("완료","",cafeDate) #완료 글자 제거 
  cafeDate <- trimws(cafeDate) # 공백 제거
  cafeDate <- gsub("\\\n","",cafeDate) #\n 글자 제거 
  cafeDate <- gsub("\\\t","",cafeDate) #\t 글자 제거 
  
  beforeMinNum <- grep("분 전", cafeDate) #n분 전에 해당되는 데이터 위치 찾기
  beforeMinute <- as.numeric(unlist(strsplit(cafeDate[beforeMinNum], "분 전"))) #해당 분 숫자 추출 
  beforeMinDate <- as.Date(Sys.time() - beforeMinute*60) #시스템 날짜와 연산 
  beforeMinDate <- paste0(as.character(beforeMinDate), ".") #날짜로 변환, 기존 날짜 데이터 뒤에 .이 붙어서 한꺼번에 처리하려고 . 붙임 
  
  beforeHourNum <- grep("시간 전", cafeDate) #n시간 전에 해당되는 데이터 위치 찾기
  beforeHour <- as.numeric(unlist(strsplit(cafeDate[beforeHourNum], "시간 전"))) #해당 분 숫자 추출
  beforeHourDate <- as.Date(Sys.time() - beforeHour*60*60) #시스템 날짜와 연산 
  beforeHourDate <- paste0(as.character(beforeHourDate), ".") #날짜로 변환, 기존 날짜 데이터 뒤에 .이 붙어서 한꺼번에 처리하려고 . 붙임 
  
  cafeDate[beforeMinNum] <- beforeMinDate #분 위치에 분 데이터 입력 
  cafeDate[beforeHourNum] <- beforeHourDate #시간 위치에 시간 데이터 입력 
  
  cafeDate <- substring(cafeDate,0,(nchar(cafeDate)-1)) #데이터 맨 뒤 . 제거
  cafeDate <- gsub("\\.","-",cafeDate) #.값을 -으로 변환
  
  cafeDate <- as.Date(cafeDate) #날짜 타입으로 변환
  return(cafeDate)
}

ch=wdman::chrome(port=4567L) #크롬드라이버를 포트 4567번에 배정
remDr=remoteDriver(port=4567L, browserName='chrome') #remort설정


# driver <- rsDriver(port=4568L, browser=c("chrome"), chromever="76.0.3809.126", extraCapabilities = eCaps) #chrome driver version error 시 사용
# remDr=remoteDriver(port=4568L, browserName='chrome') #remort설정

remDr$open() #크롬 Open
remDr$navigate(urlSearch) #설정 URL로 이동

frontPage <- remDr$getPageSource() #페이지 전체 소스 가져오기
cafeTitle <- read_html(frontPage[[1]]) %>% html_nodes('.ellipsis._ellipsisArticleTitle') %>%  html_text() %>% trimws() #카페글 제목 가져오기
cafeDate <- read_html(frontPage[[1]]) %>% html_nodes('.tit_sub.txt_block') %>%  html_text() %>% trimws() #날짜 가져오기
cafeUrl <- read_html(frontPage[[1]]) %>% html_nodes('.url') %>%  html_text() %>% trimws() #링크 가져오기
cafeName <- read_html(frontPage[[1]]) %>% html_nodes('.cafe_name') %>%  html_text() %>% trimws() #카페 명칭 가져오기

flag <- TRUE #반복문 종료 flag

for (i in 2:11) {
  if(i==8){
    while (flag) {
      webElem <- remDr$findElements(using = 'xpath',value = paste0('//*[@id="content_srch"]/div[3]/div[2]/button[',i,']')) #버튼 element 찾기
      remDr$mouseMoveToLocation(webElement = webElem[[1]]) #해당 버튼으로 포인터 이동
      remDr$click() #버튼 클릭
      Sys.sleep(0.5) #잠시 동작 멈춤
      
      frontPage <- remDr$getPageSource() #페이지 전체 소스 가져오기
      cafeTitleTemp <- read_html(frontPage[[1]]) %>% html_nodes('.ellipsis._ellipsisArticleTitle') %>%  html_text() %>% trimws() #카페글 제목 가져오기
      cafeDateTemp <- read_html(frontPage[[1]]) %>% html_nodes('.tit_sub.txt_block') %>%  html_text() %>% trimws() #날짜 가져오기
      cafeUrlTemp <- read_html(frontPage[[1]]) %>% html_nodes('.url') %>%  html_text() %>% trimws() #링크 가져오기
      cafeNameTemp <- read_html(frontPage[[1]]) %>% html_nodes('.cafe_name') %>%  html_text() %>% trimws() #카페 명칭 가져오기
      
      cafeTitle <- append(cafeTitle, cafeTitleTemp) # 데이터 병합 
      cafeDate <- append(cafeDate, cafeDateTemp) # 데이터 병합 
      cafeUrl <- append(cafeUrl, cafeUrlTemp) # 데이터 병합 
      cafeName <- append(cafeName, cafeNameTemp) # 데이터 병합 
      
      pageNum <- read_html(frontPage[[1]]) %>% html_nodes(xpath='//*[@id="content_srch"]/div[3]/div[2]/button[8]') %>%  html_text() #button 8의 마지막 확인
      if(length(grep("선택됨",pageNum))){
        flag <- FALSE #반복문 종료 flag를 FALSE로 돌려 끝냄 
      }
    }
  }else{
    webElem <- remDr$findElements(using = 'xpath',value = paste0('//*[@id="content_srch"]/div[3]/div[2]/button[',i,']')) #버튼 element 찾기
    remDr$mouseMoveToLocation(webElement = webElem[[1]]) #해당 버튼으로 포인터 이동
    remDr$click() #버튼 클릭
    Sys.sleep(0.5) #잠시 동작 멈춤
    
    frontPage <- remDr$getPageSource() #페이지 전체 소스 가져오기
    cafeTitleTemp <- read_html(frontPage[[1]]) %>% html_nodes('.ellipsis._ellipsisArticleTitle') %>%  html_text() %>% trimws() #카페글 제목 가져오기
    cafeDateTemp <- read_html(frontPage[[1]]) %>% html_nodes('.tit_sub.txt_block') %>%  html_text() %>% trimws() #날짜 가져오기
    cafeUrlTemp <- read_html(frontPage[[1]]) %>% html_nodes('.url') %>%  html_text() %>% trimws() #링크 가져오기
    cafeNameTemp <- read_html(frontPage[[1]]) %>% html_nodes('.cafe_name') %>%  html_text() %>% trimws() #카페 명칭 가져오기
    
    cafeTitle <- append(cafeTitle, cafeTitleTemp) # 데이터 병합 
    cafeDate <- append(cafeDate, cafeDateTemp) # 데이터 병합 
    cafeUrl <- append(cafeUrl, cafeUrlTemp) # 데이터 병합 
    cafeName <- append(cafeName, cafeNameTemp) # 데이터 병합 
  }
}

remDr$close() #크롬 창 종료

cafeDate <- dateProcessing(cafeDate) #수집된 날짜 전처리
cafeResult <- data.frame(Title=cafeTitle, Date=cafeDate, URL=cafeUrl, Cafe_Name=cafeName) #데이터 프레임화 시킴
write.csv(cafeResult, "cafeSearch_Result_190107.csv") #csv로 저장
