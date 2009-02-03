//
//  TableDocument.h
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

@interface TableDocument : NSDocument
{

//IBOutlets
    IBOutlet id keyChainInstance;
    IBOutlet id tablesListInstance;
    IBOutlet id tableSourceInstance;
    IBOutlet id tableContentInstance;
    IBOutlet id customQueryInstance;
    IBOutlet id tableDumpInstance;
    IBOutlet id tableStatusInstance;

    IBOutlet id tableWindow;
    IBOutlet id connectSheet;
    IBOutlet id databaseSheet;
    IBOutlet id createTableSyntaxSheet;
    IBOutlet id consoleDrawer;
	IBOutlet id variablesWindow;
    
    IBOutlet id queryProgressBar;
    IBOutlet id favoritesButton;
    IBOutlet id hostField;
    IBOutlet id socketField;
    IBOutlet id userField;
    IBOutlet id passwordField;
    IBOutlet id portField;
    IBOutlet id databaseField;

    IBOutlet id connectProgressBar;
    IBOutlet id databaseNameField;
    IBOutlet id chooseDatabaseButton;
    IBOutlet id consoleTextView;
    IBOutlet id variablesTableView;
    IBOutlet id createTableSyntaxView;
    IBOutlet id chooseEncodingButton;
    IBOutlet NSTabView *tableTabView;
	IBOutlet NSScrollView *scrollView;

    SMCPConnection *mySQLConnection;
	
    NSArray *favorites;
    NSArray *variables;
    NSString *selectedDatabase;
    NSString *selectedFavorite;
    NSString *mySQLVersion;
    NSUserDefaults *prefs;
}

//start sheet
- (IBAction)connectToDB:(id)sender;
- (IBAction)connect:(id)sender;
- (IBAction)closeSheet:(id)sender;
- (IBAction)chooseFavorite:(id)sender;
- (void)setFavorites;
- (void)addToFavoritesHost:(NSString *)host socket:(NSString *)socket user:(NSString *)user password:(NSString *)password
            port:(NSString *)port database:(NSString *)database;

//alert sheets method
- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(NSString *)contextInfo;

//database methods
- (IBAction)setDatabases:(id)sender;
- (IBAction)chooseDatabase:(id)sender;
- (IBAction)addDatabase:(id)sender;
- (IBAction)closeDatabaseSheet:(id)sender;
- (IBAction)removeDatabase:(id)sender;

//console methods
- (IBAction)toggleConsole:(id)sender;
- (void)toggleConsole;
- (IBAction)clearConsole:(id)sender;
- (BOOL)consoleIsOpened;
- (void)showMessageInConsole:(NSString *)message;
- (void)showErrorInConsole:(NSString *)error;

//encoding methods
- (void)setEncoding:(NSString *)encoding;
- (void)detectEncoding;
- (NSString *)getSelectedEncoding;
- (IBAction)chooseEncoding:(id)sender;
- (BOOL)supportsEncoding;

//other methods
- (NSString *)host;
- (void)doPerformQueryService:(NSString *)query;
- (IBAction)showCreateTableSyntax:(id)sender;
- (void)closeConnection;
- (void)tableOperation:(NSString *)operation;

//getter methods
- (NSString *)database;
- (NSString *)table;
- (NSString *)mySQLVersion;
- (NSString *)user;

//notification center methods
- (void)willPerformQuery:(NSNotification *)notification;
- (void)hasPerformedQuery:(NSNotification *)notification;
- (void)applicationWillTerminate:(NSNotification *)notification;

//menu methods
- (IBAction)import:(id)sender;
- (IBAction)export:(id)sender;
- (BOOL)validateMenuItem:(NSMenuItem *)anItem;
- (IBAction)viewStructure:(id)sender;
- (IBAction)viewContent:(id)sender;
- (IBAction)viewQuery:(id)sender;
- (IBAction)viewStatus:(id)sender;
- (IBAction)showVariables:(id)sender;
- (IBAction)flushPrivileges:(id)sender;
- (IBAction)analyzeTable:(id)sender;
- (IBAction)checkTable:(id)sender;
- (IBAction)flushTable:(id)sender;
- (IBAction)optimizeTable:(id)sender;
- (IBAction)repairTable:(id)sender;

//toolbar methods
- (void)setupToolbar;
- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag;
- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar*)toolbar;
- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar*)toolbar;
- (BOOL)validateToolbarItem:(NSToolbarItem *)toolbarItem;

//NSDocument methods
- (NSString *)windowNibName;
- (void)windowControllerDidLoadNib:(NSWindowController *)aController;
- (void)windowWillClose:(NSNotification *)aNotification;

//NSWindow delegate methods
- (BOOL)windowShouldClose:(id)sender;

//SMySQL delegate methods
- (void)willQueryString:(NSString *)query;
- (void)queryGaveError:(NSString *)error;

//splitView delegate methods
- (BOOL)splitView:(NSSplitView *)sender canCollapseSubview:(NSView *)subview;
- (float)splitView:(NSSplitView *)sender constrainMaxCoordinate:(float)proposedMax ofSubviewAt:(int)offset;
- (float)splitView:(NSSplitView *)sender constrainMinCoordinate:(float)proposedMin ofSubviewAt:(int)offset;

//tableView datasource methods
- (int)numberOfRowsInTableView:(NSTableView *)aTableView;
- (id)tableView:(NSTableView *)aTableView
            objectValueForTableColumn:(NSTableColumn *)aTableColumn
            row:(int)rowIndex;

//for freeing up memory
- (void)dealloc;

@end
