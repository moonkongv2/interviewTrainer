# OralTrainer

OralTrainer는 스포츠지도사 2급 구술 시험을 준비하기 위한 랜덤 질문 연습 iOS 앱입니다. 앱에 포함된 `questions.json` 데이터를 바탕으로 문제를 무작위로 보여주고, 답변 확인과 취약 문제 복습을 도와줍니다.

## 주요 기능

- 랜덤 질문 연습
- 카테고리별 문제 연습
- 답변 보기
- 취약 문제 저장
- 취약 문제만 따로 연습
- 질문 목록 검색

## questions.json 형식

`questions.json`은 앱 번들에 포함되는 JSON 파일이며, 최상위 값은 질문 객체 배열입니다.

```json
[
  {
    "id": "q-001",
    "category": "운동생리학",
    "question": "유산소 운동과 무산소 운동의 차이를 설명하시오.",
    "answer": "유산소 운동은 산소를 이용해 장시간 에너지를 공급하는 운동이고, 무산소 운동은 짧고 강한 활동에서 빠르게 에너지를 만드는 운동입니다.",
    "tags": ["에너지대사", "운동처방"]
  },
  {
    "id": "q-002",
    "category": "응급처치",
    "question": "운동 중 발목 염좌가 발생했을 때 초기 대처 방법을 설명하시오.",
    "answer": "운동을 중단하고 손상 부위를 보호한 뒤 냉찜질, 압박, 거상 등을 시행합니다. 통증이나 부종이 심하면 의료기관 평가를 받도록 합니다.",
    "tags": ["염좌", "RICE"]
  }
]
```

## 필드 설명

- `id`: 질문의 고유 식별자입니다.
- `category`: 질문 분류입니다. 예: `운동생리학`, `스포츠심리학`, `지도방법론`, `응급처치`, `스포츠윤리`
- `question`: 사용자에게 표시할 구술 질문입니다.
- `answer`: 사용자가 확인할 모범 답변 또는 핵심 답변입니다.
- `tags`: 검색과 분류 보조에 사용할 태그 배열입니다.

## 질문 추가 규칙

- `id`는 반드시 고유해야 합니다.
- `category` 이름은 일관되게 사용해야 합니다.
- `tags`는 빈 배열(`[]`)이어도 됩니다.
- `question`과 `answer`는 비어 있으면 안 됩니다.

## 빌드 방법

1. Xcode에서 `interviewTrainer.xcodeproj`를 엽니다.
2. 실행 대상 시뮬레이터 또는 기기를 선택합니다.
3. `interviewTrainer` 스킴으로 빌드 및 실행합니다.

터미널에서는 다음 명령으로 빌드할 수 있습니다.

```bash
xcodebuild -project interviewTrainer.xcodeproj \
  -scheme interviewTrainer \
  -destination 'generic/platform=iOS Simulator' \
  -derivedDataPath /private/tmp/interviewTrainerDerivedData \
  build
```

## 현재 사용하지 않는 것

현재 앱은 단순한 로컬 학습 앱으로 유지하고 있으며, 다음 기능이나 저장소를 사용하지 않습니다.

- 서버
- 로그인
- iCloud
- CoreData
- SwiftData
