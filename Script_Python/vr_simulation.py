# %% 패키지 로드
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import yfinance as yf

# %% 1. 과거 10년치 TQQQ 데이터 가져오기
tqqq_data = yf.download('TQQQ', start='2013-01-01', end='2023-12-31')
tqqq_prices_actual = tqqq_data['Close'].dropna().values  # 실제 종가 데이터

# %% 2. 랜덤 워크 기반 가상 데이터 생성
np.random.seed(42)
days = len(tqqq_prices_actual)  # 실제 데이터와 동일한 길이
tqqq_prices_random = [100]  # 시작 가격 $100
for _ in range(days - 1):
    tqqq_prices_random.append(tqqq_prices_random[-1] * np.exp(np.random.normal(0, 0.02)))

# %% 3. VR 시뮬레이션 함수 정의
def vr_simulation(prices, G, band_width, pool_limit, cycles=14):
    """VR 방법을 적용한 수익률/변동성 계산 시뮬레이션"""
    pool = 1000  # 초기 Pool ($)
    shares = 10  # 초기 주식 보유 수량
    initial_value = shares * prices[0]
    V = initial_value  # 초기 V 값
    portfolio_values = []  # 주식 평가금 기록
    cash_balances = []  # 현금 잔고 기록
    
    for i in range(0, len(prices), cycles):  # 14일마다 리밸런싱
        # 현재 사이클 종료 가격
        current_price = prices[min(i + cycles - 1, len(prices) - 1)]
        portfolio_value = shares * current_price
        
        # 밴드 설정
        min_band = V * (1 - band_width)
        max_band = V * (1 + band_width)
        
        # 리밸런싱
        if portfolio_value < min_band:  # 매수
            buy_amount = min(pool, (min_band - portfolio_value))
            buy_shares = buy_amount // current_price
            shares += buy_shares
            pool -= buy_shares * current_price
        elif portfolio_value > max_band:  # 매도
            sell_amount = portfolio_value - max_band
            sell_shares = sell_amount // current_price
            shares -= sell_shares
            pool += sell_shares * current_price
        
        # 새로운 V 값 계산
        V = V + pool / G + (portfolio_value - V) / (2 * np.sqrt(G))
        V = max(V, 0)  # V는 음수가 될 수 없음
        
        # 기록 저장
        portfolio_values.append(portfolio_value + pool)
        cash_balances.append(pool)
    
    # 결과 반환 조건 추가
    if len(portfolio_values) > 1:  # 최소 2개 데이터 필요
        portfolio_values = np.array(portfolio_values)  # 리스트를 numpy 배열로 변환
        diffs = np.diff(portfolio_values)  # 차분 계산
        valid_mask = portfolio_values[:-1] > 0  # 유효한 값 필터 (portfolio_values[:-1]와 맞춤)
        if valid_mask.sum() > 0:  # 유효한 데이터가 있을 때만 계산
            valid_diffs = diffs[valid_mask[:len(diffs)]]  # valid_mask를 diffs 길이에 맞게 자르기
            valid_portfolio = portfolio_values[:-1][valid_mask[:len(diffs)]]
            volatility = np.std(valid_diffs / valid_portfolio)
        else:
            volatility = 0
        returns = (portfolio_values[-1] - initial_value) / initial_value
    else:  # 데이터가 부족하면 기본 값 반환
        returns = 0
        volatility = 0
    
    return returns, volatility, portfolio_values


# %% 4. 다양한 변수 조합 시뮬레이션
G_values = [10, 20, 50]  # G 값
band_widths = [0.10, 0.15, 0.20]  # 밴드폭 (±10%, ±15%, ±20%)
pool_limits = [0.25, 0.5, 0.75]  # Pool 사용 비율

results_actual = []
results_random = []

for G in G_values:
    for band in band_widths:
        for pool_limit in pool_limits:
            # 실제 데이터 시뮬레이션
            returns_a, volatility_a, _ = vr_simulation(tqqq_prices_actual, G, band, pool_limit)
            results_actual.append({"Data": "Actual", "G": G, "Band": band, "Pool Limit": pool_limit, 
                                   "Returns": returns_a, "Volatility": volatility_a})
            # 랜덤 워크 데이터 시뮬레이션
            returns_r, volatility_r, _ = vr_simulation(tqqq_prices_random, G, band, pool_limit)
            results_random.append({"Data": "Random", "G": G, "Band": band, "Pool Limit": pool_limit, 
                                   "Returns": returns_r, "Volatility": volatility_r})

# %% 데이터프레임 생성
results_df = pd.DataFrame(results_actual + results_random)

# %% 5. 결과 분석 데이터 표시
import ace_tools as tools; tools.display_dataframe_to_user(name="VR Simulation Results (Actual vs Random)", dataframe=results_df)

# %% %% 6. 결과 시각화: 실제 데이터 vs 랜덤 워크 데이터 비교
plt.figure(figsize=(10, 6))
for data_type in ["Actual", "Random"]:
    subset = results_df[results_df["Data"] == data_type]
    plt.scatter(subset["Volatility"], subset["Returns"], label=f"{data_type} Data")

plt.xlabel("Volatility")
plt.ylabel("Returns")
plt.title("TQQQ Value Re-balancing Simulation: Returns vs Volatility")
plt.legend()
plt.grid()
plt.show()
