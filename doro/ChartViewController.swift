//
//  ChartViewController.swift
//  doro
//
//  Created by Vmock on 25/07/16.
//  Copyright © 2016 comicsanshq. All rights reserved.
//

import UIKit
import SwiftCharts
import Realm
import RealmSwift

class ChartViewController: UIViewController {

	private var chart: Chart? // arc
	// http://stackoverflow.com/questions/24007461/how-to-enumerate-an-enum-with-string-type
	enum DaysOfWeek: String {
		case Monday = "M",
		Tuesday = "T",
		Wednesday = "W",
		Thursday = "Th",
		Friday = "Fr"

		static let allValues = [Monday, Tuesday, Wednesday, Thursday, Friday]
	}

	@IBAction func dismissButtonTapped(sender: UIButton) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	//NOTE: I _might_ have prematurely tried to be cute here. But alteast I have type safety ¯\_(ツ)_/¯
	var chartData: [DaysOfWeek:(Int, Int)] = [:]

	let arr = []

	private func generateChart() -> Chart {
		let successColor = UIColor.blueColor().colorWithAlphaComponent(0.6)
		let failureColor = UIColor.redColor().colorWithAlphaComponent(0.6)

		let zero = ChartAxisValueDouble(0)

		let labelSettings = ChartLabelSettings(font:  UIFont.systemFontOfSize(12))

		let barModels = DaysOfWeek.allValues.enumerate().map {
			(index, day) -> ChartStackedBarModel  in
			// TODO: Un force unwrap
			let success = Double(chartData[day]!.0)
			let failure = Double(chartData[day]!.1)
			let items = [
				ChartStackedBarItemModel(quantity: success, bgColor: successColor),
				ChartStackedBarItemModel(quantity: failure, bgColor: failureColor),
			]
			return ChartStackedBarModel(constant: ChartAxisValueString(day.rawValue, order: index + 1, labelSettings: labelSettings), start: zero, items: items)
		}


		let (yValues, xValues) = (
			0.stride(through: 20, by: 1).map {ChartAxisValueDouble(Double($0), labelSettings: labelSettings)},
			[ChartAxisValueString("", order: 0, labelSettings: labelSettings)] + barModels.map {
				$0.constant} + [ChartAxisValueString("", order: 5, labelSettings: labelSettings)]
		)

		let xModel = ChartAxisModel(axisValues: xValues, axisTitleLabel: ChartAxisLabel(text: "X-Axis title", settings: labelSettings))
		let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: "Y-Axis title", settings: labelSettings.defaultVertical()))


		let frame = CGRect(x: 0, y: 70, width: view.frame.width - 50, height: view.frame.height - 70)
		let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings:chartSettings, chartFrame: frame, xModel: xModel, yModel: yModel)

		let (xAxis, yAxis, innerFrame) = (coordsSpace.xAxis, coordsSpace.yAxis, coordsSpace.chartInnerFrame)
		let chartStackedBarsLayer = ChartStackedBarsLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, barModels: barModels, horizontal: false, barWidth: 40, animDuration: 2)
		let settings = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.blackColor(), linesWidth: 0.1)
		let guidelinesLayer = ChartGuideLinesDottedLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, settings: settings)
		return Chart(
			frame: frame,
			layers: [
				xAxis,
				yAxis,
				guidelinesLayer,
				chartStackedBarsLayer
			]
		)

	}

	var chartSettings: ChartSettings {
		let chartSettings = ChartSettings()
		chartSettings.leading = 10
		chartSettings.top = 10
		chartSettings.trailing = 10
		chartSettings.bottom = 10
		chartSettings.labelsToAxisSpacingX = 5
		chartSettings.labelsToAxisSpacingY = 5
		chartSettings.axisTitleLabelsToLabelsSpacing = 4
		chartSettings.axisStrokeWidth = 0.2
		chartSettings.spacingBetweenAxesX = 8
		chartSettings.spacingBetweenAxesY = 8
		return chartSettings
	}

	func generateData() {
		let realm = try! Realm()
		let calendar = NSCalendar.currentCalendar()
		let components = calendar.components([.Year, .WeekOfYear, .Weekday], fromDate: NSDate())
		components.timeZone = NSTimeZone(name: "UTC")
		for (index, day) in DaysOfWeek.allValues.enumerate() {
			components.weekday = index + 2
			let dayOfWeek = calendar.dateFromComponents(components)
			components.weekday = index + 3
			let nextDay = calendar.dateFromComponents(components)
			let pomos = realm.objects(PomodoroTracker.self).filter("workStartTime BETWEEN {%@, %@}", dayOfWeek!, nextDay!)
			let successes = pomos.filter("wasSuccessfulOnDBSave = 1")
			let failures = pomos.filter("wasSuccessfulOnDBSave = 0")
			chartData[day] = (successes.count, failures.count)
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		generateData()
		self.chart?.clearView()
		let chart = generateChart()
		view.addSubview(chart.view)
		self.chart = chart
	}
}
