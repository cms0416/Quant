
################################################################################
## 라이브러리 로드
library(tidyverse)
library(data.table)
library(readxl)
library(writexl)

library(RSelenium)
library(seleniumPipes)
library(rvest)
library(httr)

library(wdman)
library(binman)
library(webdriver)
################################################################################

## 접속할 url 설정
url <- "https://cafe.naver.com/infinitebuying"

## 크롬 드라이버 버전 확인
binman::list_versions('chromedriver')

## 크롬 브라우저
wdman::chrome(port = 4567L)

## 셀레니움 서버
rD <- rsDriver(
  port = 4567L,
  browser = 'chrome'
)

remDr <- rD$client


## url 접속
remDr$navigate(url)

## 게시판 열기기
remDr$findElement(using = "xpath", value = '/html/body/div[3]/div/div[6]/div[1]/div[2]/div[2]/ul[4]/li[1]/a')$clickElement()

## 게시판 검색어 입력
remDr$findElement(using = 'class', 'input_component')$sendKeysToElement(list("TQQQ"))

## 검색 버튼 클릭
remDr$findElement(using = 'class', 'btn-search-green')$clickElement()

## 검색 창 클릭
# remDr$findElement(using = "xpath", value = '/html/body/div[1]/div/div[8]/form/div[3]/div/input')$clickElement()

## 검색어 입력
# remDr$findElement(using = "xpath", value = '/html/body/div[1]/div/div[7]/form/div[3]/div/input/option[value() = "tqqq"]')

## 검색 버튼 클릭
# remDr$findElement(using = "xpath", value = '/html/body/div[1]/div/div[7]/form/div[3]/button')$clickElement()


frontPage <- remDr$getPageSource()







## 페이지 로딩 시간 대기
Sys.sleep(1)





#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
ch = wdman::chrome(port=4567L)

## 4567번 포트와 크롬 연결
remDr <- remoteDriver(
  remoteServerAddr = "localhost",
  port = 4567L,
  browserName = "chrome"
)

## 크롬 실행
remDr$open()