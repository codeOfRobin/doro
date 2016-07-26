//
//  ChartViewController.swift
//  doro
//
//  Created by Vmock on 25/07/16.
//  Copyright © 2016 comicsanshq. All rights reserved.
//

import UIKit
import SwiftCharts

class ChartViewController: UIViewController {

	private var chart: Chart? // arc
	
	private func generateChart() -> Chart {
		let color0 = UIColor.grayColor().colorWithAlphaComponent(0.6)
		let color1 = UIColor.blueColor().colorWithAlphaComponent(0.6)
		let color2 = UIColor.redColor().colorWithAlphaComponent(0.6)
		let color3 = UIColor.greenColor().colorWithAlphaComponent(0.6)
		
		let zero = ChartAxisValueDouble(0)
		
		let labelSettings = ChartLabelSettings(font:  UIFont.systemFontOfSize(12))
		
		let barModels = [
			ChartStackedBarModel(constant: ChartAxisValueString("M", order: 1, labelSettings: labelSettings), start: zero, items: [
				ChartStackedBarItemModel(quantity: 20, bgColor: color0),
				ChartStackedBarItemModel(quantity: 60, bgColor: color1),
				ChartStackedBarItemModel(quantity: 30, bgColor: color2),
				ChartStackedBarItemModel(quantity: 20, bgColor: color3)
				]),
			ChartStackedBarModel(constant: ChartAxisValueString("T", order: 2, labelSettings: labelSettings), start: zero, items: [
				ChartStackedBarItemModel(quantity: 40, bgColor: color0),
				ChartStackedBarItemModel(quantity: 30, bgColor: color1),
				ChartStackedBarItemModel(quantity: 10, bgColor: color2),
				ChartStackedBarItemModel(quantity: 30, bgColor: color3)
				]),
			ChartStackedBarModel(constant: ChartAxisValueString("W", order: 3, labelSettings: labelSettings), start: zero, items: [
				ChartStackedBarItemModel(quantity: 30, bgColor: color0),
				ChartStackedBarItemModel(quantity: 50, bgColor: color1),
				ChartStackedBarItemModel(quantity: 20, bgColor: color2),
				ChartStackedBarItemModel(quantity: 10, bgColor: color3)
				]),
			ChartStackedBarModel(constant: ChartAxisValueString("Th", order: 4, labelSettings: labelSettings), start: zero, items: [
				ChartStackedBarItemModel(quantity: 10, bgColor: color0),
				ChartStackedBarItemModel(quantity: 30, bgColor: color1),
				ChartStackedBarItemModel(quantity: 50, bgColor: color2),
				ChartStackedBarItemModel(quantity: 5, bgColor: color3)
				]),
			ChartStackedBarModel(constant: ChartAxisValueString("F", order: 5, labelSettings: labelSettings), start: zero, items: [
				ChartStackedBarItemModel(quantity: 10, bgColor: color0),
				ChartStackedBarItemModel(quantity: 30, bgColor: color1),
				ChartStackedBarItemModel(quantity: 50, bgColor: color2),
				ChartStackedBarItemModel(quantity: 5, bgColor: color3)
				])
		]
		
		let (yValues, xValues) = (
			0.stride(through: 150, by: 20).map {ChartAxisValueDouble(Double($0), labelSettings: labelSettings)},
			[ChartAxisValueString("", order: 0, labelSettings: labelSettings)] + barModels.map{$0.constant} + [ChartAxisValueString("", order: 5, labelSettings: labelSettings)]
		)
		
		let xModel = ChartAxisModel(axisValues: xValues, axisTitleLabel: ChartAxisLabel(text: "X-Axis title", settings: labelSettings))
		let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: "Y-Axis title", settings: labelSettings.defaultVertical()))
		
		
		let frame = CGRectMake(0, 70, view.frame.width - 50, view.frame.height - 70)
		let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings:chartSettings, chartFrame: frame, xModel: xModel, yModel: yModel)
		
		let (xAxis, yAxis, innerFrame) = (coordsSpace.xAxis, coordsSpace.yAxis, coordsSpace.chartInnerFrame)
		let chartStackedBarsLayer = ChartStackedBarsLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, barModels: barModels, horizontal: false, barWidth: 40, animDuration: 2)
		let settings = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.whiteColor(), linesWidth: 0.1)
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
	override func viewDidLoad() {
		super.viewDidLoad()
		self.chart?.clearView()
		let chart = generateChart()
		view.addSubview(chart.view)
		self.chart = chart
	}
}
