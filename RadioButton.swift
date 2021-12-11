//
//  RadioButton.swift
//
//  Created by jjw on 2021/12/07.

import RxSwift
import UIKit
import Then
import SnapKit
import RxRelay
import RxGesture

/// 라디오 버튼
class RadioButton: UIView {
    /// 텍스트와 체크 이미지 사이 간격
    @IBInspectable
    var spaceInset: CGFloat = 8
    
    /// 라디오 버튼 타이틀
    var title = "" {
        didSet {
            textLabel.text = title
        }
    }
    
    /// 선택 됬 을때 이미지
    var selectImage = UIImage(named: "radioOn")
    /// 선택 해제시 이미지
    var unselectImage = UIImage(named: "radioOff")

    /// 체크 이미지 뷰
    private var checkImageView = UIImageView()
    
    /// 버튼 텍스트 뷰
    private var textLabel = UILabel().then {
        $0.font = .fontRegularSize13
        $0.textColor = .gray24
        $0.textAlignment = .left
    }
    
    /// 선택 여부 옵저블
    var isSelected = BehaviorRelay<Bool>(value: false)
    
    let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createView()
        bind()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createView()
        bind()
    }
    
    /// 소스로 뷰 셋팅
    private func createView() {
        self.addSubview(checkImageView)
        checkImageView.image = unselectImage
        self.addSubview(textLabel)
        
        checkImageView.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading)
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
        }
        
        textLabel.snp.makeConstraints { make in
            make.leading.equalTo(checkImageView.snp.trailing).offset(spaceInset)
            make.centerY.equalTo(self.snp.centerY)
            make.trailing.equalTo(self.snp.trailing)
        }
    }
    
    /// 바인딩
    private func bind() {
        self.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.isSelected.accept(true)
            })
            .disposed(by: disposeBag)
        
        isSelected
            .bind(to: self.rx.isSelected)
            .disposed(by: disposeBag)
    }
    
    /// 선택여부 변경됬을때 이미지 변경
    fileprivate func setSelected(isSelected: Bool) {
        let image = isSelected ? selectImage : unselectImage
        checkImageView.image = image
    }
}

extension Reactive where Base: RadioButton {
    fileprivate var isSelected: Binder<Bool> {
        return Binder(self.base) { view, isSelected in
            view.setSelected(isSelected: isSelected)
        }
    }
}
