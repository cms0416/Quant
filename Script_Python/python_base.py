#%% 
"""퀀트 투자 포트폴리오 만들기""" 
'''퀀트 투자 포트폴리오 만들기'''

# %% 따옴표를 3 개 사용할 경우 줄 바꿈을 통해 여러 줄의 문자열을 만들 수 있다.
multiline = """ Life is too short 
You need python""" 

print ( multiline )

# %% 문자열 맨 앞에 f를 붙이면 f-string 포매팅이 선언되며, 중괄호 안에 
#    변수를 넣으면 해당 부분에 변수의 값이 입력 된다 .
name = '조문수'
birth = '1984' 

f'나의 이름은 {name}이며, {birth}년에 태어났습니다.'

# %% 문자열 길이 구하기 : len()
a = 'Life is too short' 
len(a)

# %% 문자열 치환하기 : replace()
#    문자열.replace(a, b) : a를 b로 치환
var = '퀀트 투자 포트폴리오 만들기' 
var.replace (' ', '_')


# %% 문자열 나누기 : split()
var = '퀀트 투자 포트폴리오 만들기' 
var.split(' ')

# %% 문자열 인덱싱(파이썬은 숫자가 0부터 시작 → 2는 세번째 문자)
var = 'Quant'
var[2]

# %% 인덱싱에 마이너스(-) 기호를 붙이면 문자열 뒤에서 부터 읽는다.
var[-2]

# %% 슬라이싱 var[시작:마지막], 이때 마지막 번호는 미포함
#    var[0:3] → 0이상 3미만(첫번째 부터 세번째 까지)
var[:3]

# %%
var[3:]

# %% 리스트 : 연속된 데이터 표현, 대괄호([]) 이용해 생성
#    리스트_숫자
list_num = [1, 2, 3]
print(list_num)

# %% 리스트_문자열
list_char = ['a', 'b', 'c']
print(list_char)

# %% 리스트_복합
list_complex = [1, 'a', 2]
print(list_complex)

# %% 리스트_중첩
list_nest = [1, 2, ['a', 'b']]
print(list_nest)

# %% 리스트 인덱싱
var = [1, 2, ['a', 'b', 'c']]
var[0]

# %% 리스트 인덱싱
var[2]

# %% 중첩된 리스트에서 내부 리스트 인덱싱
var[2][0]

# %% 리스트 슬라이싱
var = [1, 2, 3, 4, 5]
var[0:2]

# %% 리스트 연산 + : 두 리스트를 하나로 합치기
a = [1, 2, 3]
b = [4, 5, 6]

a + b

# %% 리스트 연산 * : 해당 리스트를 n번 반복
a = [1, 2, 3]
a * 3

# %% 리스트에 요소 추가 append() : 리스트 마지막에 데이터 추가
var = [1, 2, 3]
var.append(4)
print(var)

# %% append() 함수 내에 리스트 입력 시 중첩된 형태로 추가
var = [1, 2, 3]
var.append([4, 5])
print(var)

# %% extend() : 리스트 내에 중첩된 형태가 아닌 단일 리스트로 확장
var = [1, 2, 3]
var.extend([4, 5])
print(var)

# %% 리스트 수정 : 인덱싱 이용
var = [1, 2, 3, 4, 5]
var[2] = 10
print(var)

# %% 리스트 수정 : 인덱싱 이용
var[3] = ['a', 'b', 'c']
print(var)

# %% 리스트 수정 : 스라이싱 이용
var[0 : 2] = ['가', '나']
print(var)

# %% 리스트 내 요소 삭제 : del 명령어 / 인덱싱
var = [1, 2, 3]
del var[0]
print(var)

# %% 리스트 내 요소 삭제 : del 명령어 / 슬라이싱
var = [1, 2, 3]
del var[0:2]
print(var)

# %% 슬라이싱으로 범위 지정 후 빈 리스트([]) 입력 시 데이터 삭제
var = [1, 2, 3]
var[0:2] = []
print(var)

# %% remove(x) : 리스트에서 첫 번째로 나오는 x를 삭제
var = [1, 2, 3]
var.remove(1)
print(var)

# %% pop() : 리스트의 맨 마지막 요소를 반환하고 해당 요소는 삭제
var = [1, 2, 3]
var.pop()

# %%
print(var)

# %% sort() : 리스트 내 데이터 정렬(오름차순)
var = [2, 4, 1, 3]
var.sort()
print(var)

# %% 튜플 : 리스트와 흡사하나 소괄호(()) 이용해 생성하고, 값 수정 및 삭제 불가
#    값이 하나인 경우 값 뒤에 반드시 콤마(,) 입력
var = (1, )
print(var)

# %% 튜플도 중첩 가능
var = (1, 2, ('a', 'b'))
print(var)

# %% 튜플은 값 삭제 불가
var = (1, 2)
del var[0]

# %% 튜플도 인덱싱이나 슬라이싱은 리스트와 동일
var = (1, 2, 3)
var[0]

# %%  딕셔너리 : 대응 관계를 나타내는 자료형, 중괄호({})를 이용해 생성하며 
#     키:값 형태
var = {'key1' : 1, 'key2' : 2}
print(var)
