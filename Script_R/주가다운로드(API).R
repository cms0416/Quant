### 라이브러리 로드
library(quantmod)

### 3.2.1 주가 다운로드
## getSymbols() 함수 : 야후 파이낸스 API에 접속해 데이터 다운로드 후 티커와 동일한 변수 생성
# Open: 시가, High: 고가, Low: 저가, Close: 종가, Volume: 거래량, Adjusted: 배당이 반영된 수정주가
getSymbols('TQQQ')

## Ad() 함수 : 수정주가만 선택, chart_Series() 함수 : 시계열 그래프 작성
# Cl() 함수 : Close, 즉 종가만을 선택
chart_Series(Ad(TQQQ))
chart_Series(Cl(TQQQ))

## 원하는 기간 입력 : from에는 시작시점, to에는 종료시점
## 티커와 다른 변수명에 데이터 저장시 auto.assign 인자를 FALSE로 설정
data = getSymbols('TQQQ', from = '2010-01-01', to = '2022-12-31',
           auto.assign = FALSE)

## 여러 종목 한번에 받기
ticker = c('TQQQ', 'SOXL') 
getSymbols(ticker)

### 3.2.2 국내 종목 주가 다운로드
## 코스피 상장 종목(삼성전자) : 티커.KS
getSymbols('005930.KS',
           from = '2000-01-01', to = '2018-12-31')

## 코스닥 상장 종목(셀트리온) : 티커.KQ
getSymbols("068760.KQ",
           from = '2000-01-01', to = '2018-12-31')

### 3.2.3 FRED 데이터 
## 미 국채 10년물 금리
getSymbols('DGS10', src='FRED')

chart_Series(DGS10)

## 원/달러 환율
getSymbols('DEXKOUS', src='FRED')

tail(DEXKOUS)



