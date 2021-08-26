//
//  Date+TP.swift
//  TPFoundation-Swift
//
//  Created by Topredator on 2021/8/26.
//

extension Date: NameSpaceWrappable {}
public extension NameSpace where Base == Date {
    var year: Int {
        Calendar.current.component(.year, from: base)
    }
    var month: Int {
        Calendar.current.component(.month, from: base)
    }
    var day: Int {
        Calendar.current.component(.day, from: base)
    }
    var hour: Int {
        Calendar.current.component(.hour, from: base)
    }
    var minute: Int {
        Calendar.current.component(.minute, from: base)
    }
    var second: Int {
        Calendar.current.component(.second, from: base)
    }
    var weekday: Int {
        Calendar.current.component(.weekday, from: base)
    }
    var weekOfMonth: Int {
        Calendar.current.component(.weekOfMonth, from: base)
    }
    var weekOfYear: Int {
        Calendar.current.component(.weekOfYear, from: base)
    }
    
    /// 闰年 判断
    var isLeepYear: Bool {
        let year = self.year
        return ((year % 400 == 0) || ((year % 100 != 0) && (year % 4 == 0)))
    }
    
    /// 闰月 判断
    var isLeepMonth: Bool {
        return Calendar.current.dateComponents([.quarter], from: base).isLeapMonth ?? false
    }
    /// 日期是否为今天
    var isToday: Bool {
        if fabs(base.timeIntervalSinceNow) >= 60 * 60 * 24 { return false }
        return Date().tp.day == self.day
    }
    
    fileprivate func weekday(fromSystem day: Int) -> Int {
        switch day {
            case 1: return 7
            case 2: return 1
            case 3: return 2
            case 4: return 3
            case 5: return 4
            case 6: return 5
            case 7: return 6
            default: return 0
        }
    }
    
    /// 是否 同一 星期
    var isSameWeek: Bool {
        let date = Date()
        let currentWeek = self.weekday(fromSystem: date.tp.weekday)
        let week = self.weekday(fromSystem: base.tp.weekday)
        let secondsOfDay = 86400
        let differ: TimeInterval = base.timeIntervalSince1970 - date.timeIntervalSince1970
        if differ == 0 { return true }
        else if differ > 0 { return Int(differ) < secondsOfDay * week ? true : false }
        else { return Int(-differ) < secondsOfDay * currentWeek ? true : false }
    }
    
    /// 昨天 判断
    var isYesterday: Bool {
        let date = Time.day.time(byAdding: 1, date: base)
        return date.tp.isToday
    }
    
    /// date 转 时间
    /// - Parameter format: 时间格式 (xxxx.xx.xx xx:xx:xx)
    func time(withFormat format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale.current
        return formatter.string(from: base)
    }
    
    
    enum AddDate {
        case year, month, week
        func date(byAdding index: Int, date: Date) -> Date {
            let calendar = Calendar.current
            var components = DateComponents()
            switch self {
            case .year: components.year = index
            case .month: components.month = index
            case .week: components.weekOfYear = index
            }
            return calendar.date(byAdding: components, to: date) ?? Date()
        }
    }
    enum Time {
        case day, hour, minute, second
        func time(byAdding index: Int, date: Date) -> Date {
            var seconds: Int = 1
            switch self {
            case .day: seconds = 86400
            case .hour: seconds = 3600
            case .minute: seconds = 60
            case .second: seconds = 1
            }
            let timeInterval = date.timeIntervalSinceReferenceDate + Double(seconds * index)
            return Date.init(timeIntervalSinceReferenceDate: timeInterval)
        }
    }
}
