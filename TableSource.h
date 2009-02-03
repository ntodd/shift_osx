//
//  TableSource.h
//  CocoaMySQL
//
//  Created by lorenz textor (lorenz@textor.ch) on Wed May 01 2002.
//  Copyright (c) 2002-2003 Lorenz Textor. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation; either version 2 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
//
//  More info at <http://cocoamysql.sourceforge.net/>
//  Or mail to <lorenz@textor.ch>

#import <Cocoa/Cocoa.h>
#import <MCPKit_bundled/MCPKit_bundled.h>
#import "SMCPConnection.h"
#import "SMCPResult.h"


@interface TableSource : NSObject {

    IBOutlet id tablesListInstance;

    IBOutlet id tableWindow;
    IBOutlet id indexSheet;
    IBOutlet id keySheet;
    IBOutlet id tableSourceView;
    IBOutlet id indexView;
    IBOutlet id addFieldButton;
    IBOutlet id copyFieldButton;
    IBOutlet id removeFieldButton;
    IBOutlet id addIndexButton;
    IBOutlet id removeIndexButton;
    IBOutlet id indexTypeField;
    IBOutlet id indexNameField;
    IBOutlet id indexedColumnsField;
    IBOutlet id chooseKeyButton;
    IBOutlet id tableTypeButton;

    SMCPConnection *mySQLConnection;
    SMCPResult *tableSourceResult;
    SMCPResult *indexResult;

    NSString *selectedTable;
    NSString *tableType;
    NSMutableArray *tableFields, *indexes;
    NSMutableDictionary *oldRow, *enumFields;
    NSDictionary *defaultValues;
    BOOL isEditingRow, isEditingNewRow, alertSheetOpened;
    NSUserDefaults *prefs;
}

//table methods
- (void)loadTable:(NSString *)aTable;
- (IBAction)reloadTable:(id)sender;

//edit methods
- (IBAction)addField:(id)sender;
- (IBAction)copyField:(id)sender;
- (IBAction)addIndex:(id)sender;
- (IBAction)removeField:(id)sender;
- (IBAction)removeIndex:(id)sender;
- (IBAction)typeChanged:(id)sender;

//index sheet methods
- (IBAction)openIndexSheet:(id)sender;
- (IBAction)closeIndexSheet:(id)sender;
- (IBAction)chooseIndexType:(id)sender;
- (void)closeAlertSheet;

//key sheet methods
- (IBAction)closeKeySheet:(id)sender;

//additional methods
- (void)setConnection:(SMCPConnection *)theConnection;
- (NSArray *)fetchResultAsArray:(SMCPResult *)theResult;
- (BOOL)addRowToDB;
- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(NSString *)contextInfo;

//getter methods
- (NSString *)defaultValueForField:(NSString *)field;
- (NSArray *)fieldNames;
- (NSDictionary *)enumFields;

//tableView datasource methods
- (int)numberOfRowsInTableView:(NSTableView *)aTableView;
- (id)tableView:(NSTableView *)aTableView
            objectValueForTableColumn:(NSTableColumn *)aTableColumn
            row:(int)rowIndex;
- (void)tableView:(NSTableView *)aTableView
            setObjectValue:(id)anObject
            forTableColumn:(NSTableColumn *)aTableColumn
            row:(int)rowIndex;

//tableView drag&drop datasource methods
- (BOOL)tableView:(NSTableView *)tv writeRows:(NSArray*)rows toPasteboard:(NSPasteboard*)pboard;
- (NSDragOperation)tableView:(NSTableView*)tv validateDrop:(id <NSDraggingInfo>)info proposedRow:(int)row
    proposedDropOperation:(NSTableViewDropOperation)operation;
- (BOOL)tableView:(NSTableView*)tv acceptDrop:(id <NSDraggingInfo>)info row:(int)row dropOperation:(NSTableViewDropOperation)operation;

//tableView delegate methods
- (BOOL)selectionShouldChangeInTableView:(NSTableView *)aTableView;
- (BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)command;

//slitView delegate methods
- (BOOL)splitView:(NSSplitView *)sender canCollapseSubview:(NSView *)subview;
- (float)splitView:(NSSplitView *)sender constrainMaxCoordinate:(float)proposedMax ofSubviewAt:(int)offset;
- (float)splitView:(NSSplitView *)sender constrainMinCoordinate:(float)proposedMin ofSubviewAt:(int)offset;

//last but not least
- (id)init;
- (void)dealloc;

@end
