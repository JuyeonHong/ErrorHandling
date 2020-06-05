# DispatchQueue

## Serial Queue
```
DispatchQueue(label: "test").sync {
    for i in 15..<20 {
        print("test sync \(i)")
    }
}
```

```
DispatchQueue.global().sync {
    for i in 10..<15 {
        print("global().sync \(i)")
    }
}
```

- main은 main task에서 task를 실행하는 전형적인 serial queue
```
DispatchQueue.main.async {
    for i in 5..<10 {
        print("main.async \(i)")
    }
}
```

## Global queue
```
DispatchQueue.global().async {
    for i in 15..<20 {
        print("==global.async \(i)")
    }
}
```

```
DispatchQueue.global().async {
    for i in 10..<15 {
        print("**global.async \(i)")
    }
}
```

### QoS
1. background
- 백그라운드에서 작동.
- indexing, 동기화 및 백업같이 사용자가 볼 수 없는 작업.
- 에너지 효율성에 중점을 둔다.
- 최적으로는 사용자 작업이 발생하지 않는 시간의 90% 이상을 Utility QoS level에서 실행하는 것이 좋다.
```
DispatchQueue.global(qos: .background).async {
    for i in 0..<3 {
        print("👤background \(i)")
    }
}
```
2. default
- default의 QoS 레벨은 userInitiated와 utility 사이에 있음.
```
DispatchQueue.global(qos: .default).async {
    for i in 0..<3 {
        print("🧑🏼‍⚖️default \(i)")
    }
}
```

3. unspecified
```
DispatchQueue.global(qos: .unspecified).async {
    for i in 0..<3 {
        print("🧟‍♀️unspecified \(i)")
    }
}
```

4. userInitiated
- 시용자가 시작한 작업이며, 저장된 문서를 열거나 UI에서 무언가를 클릭할 때 작업을 수행하는 것 같은 즉각적인 결과 필요.
- 사용자와 상호작용을 하려면 작업이 필요함.
- 반응성과 성능에 중점을 둔다.
```
DispatchQueue.global(qos: .userInitiated).async {
    for i in 0..<3 {
        print("🤷‍♂️userInitiated \(i)")
    }
}
```

5. userInteractive
- main thread에서 작업.
- UI 새로고침 또는 애니메이션 수행처럼 사용자와 상호작용하는 작업.
- 작업이 신속하게 끝나지 않으면 UI가 중단된 상태로 표시될 수 있다.
- 반응성과 성능에 중점을 둔다.
```
DispatchQueue.global(qos: .userInteractive).async {
    for i in 0..<3 {
        print("🧍🏻‍♀️userInteractive \(i)")
    }
}
```

6. utility
- 작업을 완료하는데 약간의 시간이 걸릴 수 있음.
- 데이터 다운로드 또는 import 같은 즉각적인 결과가 필요하지 않음.
- 반응성, 성능 및 에너지 효율성 간에 균형을 두는데 초첨을 둔다.
- 작업 시간은 몇초에서 몇분 걸린다.
```
DispatchQueue.global(qos: .utility).async {
    for i in 0..<3 {
        print("👛utility \(i)")
    }
}
```

### Sample test result
🧍🏻‍♀️userInteractive > 🧟‍♀️unspecified > 🧑🏼‍⚖️default > 🤷‍♂️userInitiated > 👛utility > 👤background
