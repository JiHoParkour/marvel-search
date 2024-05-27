# Report
- 보이는 화면을 다 구성했는가
  
  마블 영웅 검색 View Controller와 마블 영웅 좋아요 View Controller는 뷰 로직을 구현합니다.
  
  그리고 각각은 비즈니스 로직을 구현하고 뷰의 상태를 관리하기 위한 Reactor를 바인딩합니다.


- 마블 API를 사용했는가
  
  마블 영웅을 검색하기 위해 마블 API를 사용합니다.
  
  API 요청에 필요한 API key와 hash가 하드코딩되는 것을 막기 위해 빌드 세팅에 정의 후 info.plist 파일에서 참조하도록 하였습니다. 코드에서 키를 이용해 info.plist의 API key, hash에 접근합니다.


- API 호출 조건을 충족했는가
  
  API 호출 조건은 다음 두 가지입니다.
  1. 검색어 입력 사이에 0.3초 딜레이
  2. API 호출 시 이전 호출은 cancel
  각각 RxSwift의 debounce 오퍼레이터, Moya Cancellable의 cancel 메소드를 이용해 충족하였습니다.

  아래 이미지는 Network Instruments를 통해 확인한 조건 충전 전후 API 요청입니다.
  호출 조건 충족 전
  <img width="1400" alt="notCancel" src="https://github.com/JiHoParkour/marvel-search/assets/102847545/86b09dcd-a3aa-4643-87c5-9d144974bc87">

  호출 조건 충족 후
  <img width="1400" alt="cancel" src="https://github.com/JiHoParkour/marvel-search/assets/102847545/6a69f1ac-9f79-41ae-ab94-df80dfa909ac">
