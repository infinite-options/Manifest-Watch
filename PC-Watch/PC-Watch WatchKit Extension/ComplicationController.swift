//
//  ComplicationController.swift
//  PC-Watch WatchKit Extension
//
//  Created by Harshit Trehan on 6/27/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import ClockKit

class ComplicationController: NSObject, CLKComplicationDataSource {
        
    let model = UserManager.shared
    let networkModel = NetworkManager.shared

    // MARK: - Timeline Configuration
    func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
        print("entered getComplicationDescriptors")
        let descriptors = [
            CLKComplicationDescriptor(identifier: "complication", displayName: "Manifest My Space", supportedFamilies: CLKComplicationFamily.allCases)
            // Multiple complication support can be added here with more descriptors
        ]
        
        // Call the handler with the currently supported complication descriptors
        handler(descriptors)
    }
    
//    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
//        handler([.forward])
//    }
//
//    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
//        handler(Date())
//    }
//
//    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
//        handler(Date().addingTimeInterval(24*60*60))
//    }
//
//    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
//        handler(.showOnLockScreen)
//    }
    func handleSharedComplicationDescriptors(_ complicationDescriptors: [CLKComplicationDescriptor]) {
        // Do any necessary work to support these newly shared complication descriptors
        print("entered handleSharedComplicationDescriptors")
        
    }

    // MARK: - Timeline Configuration
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        // Call the handler with the last entry date you can currently provide or nil if you can't support future timelines
        print("entered getTimelineEndDate")
        
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        // Call the handler with your desired behavior when the device is locked
        print("entered getPrivacyBehavior")
        
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        print("getCurrentTimelineEntry")
        
        if complication.family == .circularSmall
        {
            print("using circular small in getCurrentTimelineEntry")
            let circularSmall = CLKComplicationTemplateCircularSmallSimpleImage(imageProvider: CLKImageProvider(onePieceImage: UIImage(named: "Complication/Circular")!))
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: circularSmall)
            handler(timelineEntry)
        }
        else if complication.family == .graphicCircular
        {
            print("using graphic circular in getCurrentTimelineEntry")
            let graphicCircular = CLKComplicationTemplateGraphicCircularImage(imageProvider: CLKFullColorImageProvider(fullColorImage: UIImage(named: "Complication/Graphic Circular")!))
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: graphicCircular)
            handler(timelineEntry)
        }
        else if complication.family == .graphicRectangular
        {
//            print("using graphic rectangular in getCurrentTimelineEntry")
//            let graphicRect = CLKComplicationTemplateGraphicRectangularStandardBody(headerTextProvider: CLKTextProvider(format: "Loaded Data"), body1TextProvider: CLKTextProvider(format: "Loaded Data"), body2TextProvider: CLKTextProvider(format: "Loaded Data"))
//            let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: graphicRect)
//            handler(timelineEntry)
            print("entered getCurrentTimelineEntry with graphic rectangular")
            
            var chosenGR : GoalRoutine?
            var unfinishedGR : GoalRoutine?
            if (self.networkModel.goalsRoutinesData != nil && self.networkModel.goalsRoutinesData!.count > 0)
            {
                for goal in self.networkModel.goalsRoutinesData!
                {
                    if (goal.isInProgress.lowercased() == "true")
                    {
                        chosenGR = goal;
                        break;
                    }
                    else if (goal.isInProgress.lowercased() == "false" && goal.isComplete.lowercased() == "false" && unfinishedGR == nil)
                    {
                        unfinishedGR = goal;
                    }
                }
            }
            
//            let graphicRectangular = CLKComplicationTemplateGraphicRectangularStandardBody()
            var headerText : CLKTextProvider
            var body1Text : CLKTextProvider
            var body2Text : CLKTextProvider
            headerText = CLKSimpleTextProvider(text: "All Goals Completed")
            body1Text = CLKSimpleTextProvider(text: "---")
            body2Text = CLKSimpleTextProvider(text: "---")
            if (chosenGR != nil)
            {
                print("in progress goal chosen")
                headerText = CLKSimpleTextProvider(text: chosenGR!.grTitle)
                body1Text = CLKSimpleTextProvider(text: "In Progress")
                body2Text = CLKSimpleTextProvider(text: "takes " + chosenGR!.expectedCompletionTime + " min")
            }
            else if (unfinishedGR != nil)
            {
                print("not started goal chosen")
                headerText = CLKSimpleTextProvider(text: unfinishedGR!.grTitle)
                body1Text = CLKSimpleTextProvider(text: "Not Started")
                body2Text = CLKSimpleTextProvider(text: "takes " + unfinishedGR!.expectedCompletionTime + " min")
            }
            else
            {
                headerText = CLKSimpleTextProvider(text: "All Goals Completed")
                body1Text = CLKSimpleTextProvider(text: "---")
                body2Text = CLKSimpleTextProvider(text: "---")
            }
            
            let holder = Date()
            let graphicRect = CLKComplicationTemplateGraphicRectangularStandardBody(headerTextProvider: headerText, body1TextProvider: body1Text, body2TextProvider: body2Text)
            let timelineEntry = CLKComplicationTimelineEntry(date: holder, complicationTemplate: graphicRect)
            handler(timelineEntry)
        }
        else
        {
            handler(nil)
        }
    }
 
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after the given date
        print("entered getTimelineEntries")
        
        if complication.family == .circularSmall
        {
            var timeLineEntries = [CLKComplicationTimelineEntry]()
            print("using circular small in getCurrentTimelineEntry")
            let circularSmall = CLKComplicationTemplateCircularSmallSimpleImage(imageProvider: CLKImageProvider(onePieceImage: UIImage(named: "Complication/Circular")!))
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: circularSmall)
            timeLineEntries.append(timelineEntry)
            
            handler(timeLineEntries)
        }
        else if complication.family == .graphicCircular
        {
            var timeLineEntries = [CLKComplicationTimelineEntry]()
            print("using graphic circular in getCurrentTimelineEntry")
            let graphicCircular = CLKComplicationTemplateGraphicCircularImage(imageProvider: CLKFullColorImageProvider(fullColorImage: UIImage(named: "Complication/Graphic Circular")!))
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: graphicCircular)
            timeLineEntries.append(timelineEntry)
            handler(timeLineEntries)
        }
        else if complication.family == .graphicRectangular {
            print("entered getTimelineEntries with graphic rectangular")
//            let userDay = model.UserDayData
            var timeLineEntries = [CLKComplicationTimelineEntry]()
            var chosenGR : GoalRoutine?
            var unfinishedGR : GoalRoutine?
            if (self.networkModel.goalsRoutinesData != nil && self.networkModel.goalsRoutinesData!.count > 0)
            {
                for goal in self.networkModel.goalsRoutinesData!
                {
                    if (goal.isInProgress.lowercased() == "true")
                    {
                        chosenGR = goal;
                        break;
                    }
                    else if (goal.isInProgress.lowercased() == "false" && goal.isComplete.lowercased() == "false" && unfinishedGR == nil)
                    {
                        unfinishedGR = goal;
                    }
                }
            }
            
//            let graphicRectangular = CLKComplicationTemplateGraphicRectangularStandardBody()
            var headerText : CLKTextProvider
            var body1Text : CLKTextProvider
            var body2Text : CLKTextProvider
            headerText = CLKSimpleTextProvider(text: "gAll Goals Completed")
            body1Text = CLKSimpleTextProvider(text: "---")
            body2Text = CLKSimpleTextProvider(text: "---")
            if (chosenGR != nil)
            {
                print("in progress goal chosen")
                headerText = CLKSimpleTextProvider(text: chosenGR!.grTitle)
                body1Text = CLKSimpleTextProvider(text: "In Progress")
                body2Text = CLKSimpleTextProvider(text: "takes " + chosenGR!.expectedCompletionTime + " min")
            }
            else if (unfinishedGR != nil)
            {
                print("not started goal chosen")
                headerText = CLKSimpleTextProvider(text: unfinishedGR!.grTitle)
                body1Text = CLKSimpleTextProvider(text: "Not Started")
                body2Text = CLKSimpleTextProvider(text: "takes " + unfinishedGR!.expectedCompletionTime + " min")
            }
            else
            {
                headerText = CLKSimpleTextProvider(text: "All Goals Completed")
                body1Text = CLKSimpleTextProvider(text: "---")
                body2Text = CLKSimpleTextProvider(text: "---")
            }
            
            let holder = Date()
            let graphicRect = CLKComplicationTemplateGraphicRectangularStandardBody(headerTextProvider: headerText, body1TextProvider: body1Text, body2TextProvider: body2Text)
            let timelineEntry = CLKComplicationTimelineEntry(date: holder, complicationTemplate: graphicRect)
            timeLineEntries.append(timelineEntry)
            
            handler(timeLineEntries)
        }
        else
        {
            handler(nil)
        }
    }
   
    
    // MARK: - Placeholder Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        print("entered getLocalizableSampleTemplate")
        
        if complication.family == .circularSmall
        {
            print("sample template entered with circular small")
            let circularSmall = CLKComplicationTemplateCircularSmallSimpleImage(imageProvider: CLKImageProvider(onePieceImage: UIImage(named: "check")!))
            handler(circularSmall)
        }
        else if complication.family == .graphicCircular
        {
            print("sample template entered with graphic circular")
            let graphicCircular = CLKComplicationTemplateGraphicCircularImage(imageProvider: CLKFullColorImageProvider(fullColorImage: UIImage(named: "Complication/Graphic Circular")!))
            handler(graphicCircular)
//            handler(nil)
        }
        else if complication.family == .graphicRectangular
        {
            print("sample template entered with graphic rectangular")
            let graphicRect = CLKComplicationTemplateGraphicRectangularStandardBody(headerTextProvider: CLKTextProvider(format: "Goal/Routine"), body1TextProvider: CLKTextProvider(format: "Status"), body2TextProvider: CLKTextProvider(format: "Completion Time"))
            handler(graphicRect)
        }
        else
        {
            handler(nil)
        }
    }
    

}

