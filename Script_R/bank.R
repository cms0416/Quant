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


##########  데이터 정리  #######################################################

신한은행_거래내역_수정 <- 신한은행_거래내역 %>% 
  select(-거래점) %>% 
  set_names(c("날짜", "시간", "적요", "출금", "입금", "내용", "잔액")) %>% 
  mutate(
    날짜 = as.Date(날짜, format = "%Y-%m-%d"),
    시간 = hms::as_hms(시간),  # hms 패키지를 사용하여 시간 형식 변환
    구분 = ifelse(출금 == 0, "입금", "출금"),
    금액 = 출금 + 입금,
    .after = 시간
  ) %>% 
  select(-c(출금, 입금)) 

신한은행_적금_수정 <- 신한은행_적금 %>% 
  select(-c(`우대금리(%)`:거래점)) %>% 
  set_names(c("날짜", "적요", "출금", "입금", "잔액", "내용")) %>% 
  mutate(
    날짜 = as.Date(날짜, format = "%Y.%m.%d"),
    시간 = NA,
    시간 = hms::as_hms(시간),  # hms 패키지를 사용하여 시간 형식 변환
    구분 = ifelse(출금 == 0, "입금", "출금"),
    금액 = 출금 + 입금, 
    .after = 날짜
  ) %>% 
  select(-c(출금, 입금)) %>% 
  mutate(계좌 = "신한_적금", .before = 1)


신한은행_이체결과_수정 <- 신한은행_이체결과 %>% 
  separate(거래일시, into = c("날짜", "시간"), sep = " ") %>% 
  mutate(
    날짜 = as.Date(날짜, format = "%Y.%m.%d"),
    시간 = hms::as_hms(시간),  # hms 패키지를 사용하여 시간 형식 변환
    금액 = `이체금액(원)` + `수수료(원)`, 
    구분 = "출금"
  ) %>% 
  select(-c(결과, 출금계좌, 받는분:`수수료(원)`, 9)) %>% 
  set_names(c("날짜", "시간", "이체계좌", "내용", "금액", "구분"))


신한은행_거래내역_합치기 <- 신한은행_거래내역_수정 %>% 
  left_join(신한은행_이체결과_수정 %>% select(-시간), 
            by = c("날짜", "내용", "금액", "구분")) %>% 
  distinct(pick(날짜:잔액), .keep_all = TRUE)






