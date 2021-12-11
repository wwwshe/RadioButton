//
//  RadioButtonGroup.swift
//
//  Created by jjw on 2021/12/07.

import RxSwift
import RxGesture

/// 라디오 버튼 그룹
class RadioButtonGroup {
    var buttons = [RadioButton]() {
        didSet {
            setButtons()
        }
    }
    
    var disposeBag = DisposeBag()
    
    /// 선택된 아이템 Idx
    var selectIdx = 0
    
    /// 하나씩 추가 할경우 대비 소스
    func append(_ item: RadioButton) {
        var buttons = self.buttons
        buttons.append(item)
        self.buttons = buttons
    }
    
    /// 버튼 셋팅
    func setButtons() {
        disposeBag = DisposeBag()
        
        var idx = 0
        for button in buttons {
            button.tag = idx
            button.isSelected
                .filter { $0 }
                .asDriver(onErrorJustReturn: false)
                .drive(onNext: { [weak self] _ in
                    self?.selectIdx = button.tag
                    self?.resetButtons(exceptIdx: button.tag)
                })
                .disposed(by: disposeBag)
            
            idx += 1
        }
    }
    
    /// 선택된 버튼 제외하고 나머지 false처리
    func resetButtons(exceptIdx: Int) {
        var idx = 0
        for button in buttons {
            if idx != exceptIdx {
                button.isSelected.accept(false)
            }
            idx += 1
        }
    }
}
