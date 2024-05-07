# Safezone-iOS
팀 Safezone의 iOS 작업 공간

<br>

## ✉️ Coding Convention
> * **주석**
  > * ///를 사용해서 문서화에 사용되는 주석을 남깁니다.
  
> * **네이밍**
  > * 클래스와 구조체
    > * 클래스와 구조체의 이름에는 `UpperCamelCase`를 사용합니다.
    > * 클래스 이름에는 `접두사Prefix` 를 붙이지 않습니다.
  > * 약어
    > * 약어로 시작하는 경우에는 소문자로 표기하고, 그 외의 경우에는 항상 대문자로 표기합니다.
    > ```
          btn -> `Btn`
          image -> `Img`
          userId -> `userID`
          password -> `PWD`
          websiteUrl -> `websiteURL`
    > ```
  > * 함수
    > * 함수 이름에는 **`lowerCamelCase`**를 사용합니다.
    > * 함수 이름 앞에는 되도록이면 **`get`**을 붙이지 않습니다.
  > * 변수
    > * 변수 이름에는 **`lowerCamelCase`**를 사용합니다.
  > * 상수
    > * 상수 이름에는 **`lowerCamelCase`**를 사용합니다.
  > * 열거형
    > - enum의 이름에는 **`UpperCamelCase`**를 사용합니다.
    > - enum의 각 case에는 **`lowerCamelCase`**를 사용합니다.
  > 프로토콜
    > - 프로토콜의 이름에는 **`UpperCamelCase`**를 사용합니다.
    > - 구조체나 클래스에서 프로토콜을 채택할 때는 콜론(**`:`**)과 빈칸을 넣어 구분하여 명시합니다.

## ✉️ Commit Convention
`타입: 부연 설명 및 이유 #이슈번호` `ex. Feat: Home 화면 UI 구현 #1`

```
🎉 Feat: 새로운 기능 추가
🔧 Fix: 버그 수정
📦️ Build: 빌드 관련 파일 수정
✅ Chore: 그 외 자잘한 수정
⚗️ Ci: CI관련 설정 수정
📝 Docs: Wiki, README 문서 (문서 추가 수정, 삭제)
🎨 Style: 스타일 (코드 형식, 세미콜론 추가, 비즈니스 로직 변경X)
♻️ Refactor: 리팩토링 (네이밍 변경, 포함)
🩹 Test: 테스트 코드 (추가, 수정, 삭제)
💥 Remove: 코드 삭제
```


## ✉️ Git Flow
> 1. issue를 생성한다.
> 2. branch를 생성한다.
> 3. add → commit → push → pull request 과정을 거친다.
> 4. pull request를 요청하면, 다른 팀원이 code review를 한다.
> 5. code review가 완료되면, pull request 요청자가 main branch로 merge한다.
> 6. 종료된 issue와 pull request의 label과 project를 관리한다.


## ✉️ Branch
- **브랜치 단위**
    - Issue 단위 = PR 단위 = View 단위
- 브랜치명
    - 브랜치는 View 단위로 생성한다.
    - 브랜치 규칙: (feature/fix/refactor/chore)/#이슈번호-(UI/Func/Server)-스크린(뷰) 명-기능설명
        `ex) feature/#1-UI-Diary-WriteView`


## ✉️ Issue & PR rules
> Issue명 = PR명
```
🎉 [FEAT]
🔧 [FIX]
♻️ [REFACTOR]
✅ [CHORE]
```

