###############################################################################################################
#
# selenium 실행 : 윈도우에서 cmd를 통해 명령 프롬프트를 연 후, 아래 명령어를 입력(cmd창은 계속 열어둔다.)
#
# cd C:\Rselenium
# java -Dwebdriver.gecko.driver="geckodriver.exe" -jar selenium-server-standalone-4.0.0-alpha-2.jar -port 4567
#
###############################################################################################################

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

## 접속합 url 설정
urlSearch <- "https://cafe.naver.com/infinitebuying"

## 크롬 드라이버 버전 확인
binman::list_versions('chromedriver')

## 크롬 브라우저
wdman::chrome(port=4567L)

## 셀레니움 서버
rD <- rsDriver(
  port = 4567L,
  browser = 'chrome',
  check = TRUE
)

remDr <- rD$client

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

## url 접속
remDr$navigate(urlSearch)

## 게시판 열기기
remDr$findElement(using = "xpath", value = '/html/body/div[3]/div/div[6]/div[1]/div[2]/div[2]/ul[4]/li[1]/a')$clickElement()

## 검색 창 클릭
remDr$findElement(using = "xpath", value = '/html/body/div[1]/div/div[7]/form/div[3]/div/input')$clickElement()

## 검색어 입력
remDr$findElement(using = "xpath", value = '/html/body/div[1]/div/div[7]/form/div[3]/div/input/option[value() = "tqqq"]')$clickElement()

## 검색 버튼 클릭
remDr$findElement(using = "xpath", value = '/html/body/div[1]/div/div[7]/form/div[3]/button')$clickElement()


frontPage <- remDr$getPageSource()







## 페이지 로딩 시간 대기
Sys.sleep(1)