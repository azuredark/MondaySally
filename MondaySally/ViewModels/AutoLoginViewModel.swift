//
//  AutoLoginViewModel.swift
//  MondaySally
//
//  Created by meng on 2021/07/08.
//

class AutoLoginViewModel {
    private var dataService: DataService?
    // MARK: - Properties
    private var autoLoginResponse: AutoLoginResponse? {
        didSet {
            self.didFinishFetch?()
        }
    }
    var error: Error? {
        didSet { self.showAlertClosure?() }
    }
    
    var failMessage: String? {
        didSet { self.showAlertClosure?() }
    }
    
    var isLoading: Bool = false {
        didSet { self.updateLoadingStatus?() }
    }
    
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFinishFetch: (() -> ())?
    
    var message: String {
        guard let message = autoLoginResponse?.message else {
            print("인터넷 통신은 완료 되었지만, 응답의 message를 upwrapping 할 수 없습니다")
            return ""
        }
        return message
    }
    
    
    // MARK: - 생성자
    init(dataService: DataService) {
        self.dataService = dataService
    }
    
    func fetchAutoLogin(){
        self.dataService?.requestFetchAutoLogin(completion: { [weak self] response, error in
            if let error = error {
                self?.error = error
                self?.isLoading = false
                return
            }
            if let isSuccess = response?.isSuccess {
                if !isSuccess {
                    self?.failMessage = response?.message
                    self?.isLoading = false
                    return
                }
            }
            self?.error = nil
            self?.isLoading = false
            self?.failMessage = nil
            self?.autoLoginResponse = response
        })
    }
}
