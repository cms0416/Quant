### 라이브러리 로드
library(quantmod)

### 야후 파이낸스 API에 접속해 TQQQ 데이터 다운로드 후 티커와 동일한 변수 생성
# Open: 시가, High: 고가, Low: 저가, Close: 종가, Volume: 거래량, Adjusted: 배당이 반영된 수정주가
getSymbols('TQQQ')

### Ad() 함수 : 수정주가만 선택, chart_Series() 함수 : 시계열 그래프 작성
chart_Series(Ad(TQQQ))

### 원하는 기간 입력 : from에는 시작시점, to에는 종료시점
### 티커와 다른 변수명에 데이터 저장시 auto.assign 인자를 FALSE로 설정
data = getSymbols('TQQQ', from = '2010-01-01', to = '2022-12-31',
           auto.assign = FALSE)



ticker = c('TQQQ', 'SOXL') 
getSymbols(ticker)


