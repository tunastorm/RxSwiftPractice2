//
//  Todo.swift
//  RxSwiftPractice2
//
//  Created by 유철원 on 8/2/24.
//

import Foundation

struct Todo: Hashable {
    var id = UUID()
    var isCompleted: Bool
    var isStared: Bool
    var title: String
}

var dummyData: [Todo] = [
    Todo(isCompleted: true, isStared: true, title: "그립톡 구매하기"),
    Todo(isCompleted: false, isStared: false, title: "사이다 구매하기"),
    Todo(isCompleted: false, isStared: true, title: "아이패드 케이스 최저가 알아보기"),
    Todo(isCompleted: false, isStared: true, title: "양말")
]
