#####  라이브러리 로드  ########################################################
library(tidyverse)
library(magrittr)
library(janitor)
library(readxl)
library(writexl)

##########  파일 불러오기  #####################################################
path_신한은행_거래내역 <- list.files(
  path = "bank/신한은행_거래내역",
  pattern = "신한은행_거래내역*", full.names = T
)

신한은행_거래내역 <- read_excel(
  path_신한은행_거래내역, 
  skip = 6, col_names = T)


path_신한은행_적금 <- list.files(
  path = "bank/신한은행_거래내역",
  pattern = "신한은행_적금*", full.names = T
)

신한은행_적금 <- read_excel(
  path_신한은행_적금, 
  skip = 6, col_names = T)


path_신한은행_이체결과 <- list.files(
  path = "bank/신한은행_이체결과",
  pattern = "신한은행_이체결과*", full.names = T
)

신한은행_이체결과 <- path_신한은행_이체결과 %>%
  # map_dfr : 행 병합(row-binding)하여 작성된 데이터프레임 반환
  map_dfr(read_excel, skip = 5, col_names = T) 




# 데이터 경로지정 및 데이터 목록
files <- list.files(
  path = "bank/신한은행_거래내역",
  pattern = "*.xlsx", full.names = T
)

# 경로지정된 생활계 파일 합치기
신한은행_거래내역 <- files %>%
  # map_dfr : 행 병합(row-binding)하여 작성된 데이터프레임 반환
  map_dfr(read_excel, skip = 6, col_names = T) %>%
  # 필요없는 열 삭제
  select(-8)

##########  데이터 정리  #######################################################