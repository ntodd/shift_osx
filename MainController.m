//
//  MainController.m
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

#import "MainController.h"
#import "KeyChain.h"
#import "TableDocument.h"


@implementation MainController

- (IBAction)openPreferences:(id)sender
/*
opens the preferences window
*/
{
//get favorites if they exist
    [favorites release];
    if ( [prefs objectForKey:@"favorites"] != nil ) {
        favorites = [[NSMutableArray alloc] initWithArray:[prefs objectForKey:@"favorites"]];
    } else {
        favorites = [[NSMutableArray array] retain];
    }
    [tableView reloadData];

    if ( [prefs boolForKey:@"reloadAfterAdding"] ) {
        [reloadAfterAddingSwitch setState:NSOnState];
    } else {
        [reloadAfterAddingSwitch setState:NSOffState];
    }
    if ( [prefs boolForKey:@"reloadAfterEditing"] ) {
        [reloadAfterEditingSwitch setState:NSOnState];
    } else {
        [reloadAfterEditingSwitch setState:NSOffState];
    }
    if ( [prefs boolForKey:@"reloadAfterRemoving"] ) {
        [reloadAfterRemovingSwitch setState:NSOnState];
    } else {
        [reloadAfterRemovingSwitch setState:NSOffState];
    }
    if ( [prefs boolForKey:@"showError"] ) {
        [showErrorSwitch setState:NSOnState];
    } else {
        [showErrorSwitch setState:NSOffState];
    }
    if ( [prefs boolForKey:@"dontShowBlob"] ) {
        [dontShowBlobSwitch setState:NSOnState];
    } else {
        [dontShowBlobSwitch setState:NSOffState];
    }
    if ( [prefs boolForKey:@"limitRows"] ) {
        [limitRowsSwitch setState:NSOnState];
    } else {
        [limitRowsSwitch setState:NSOffState];
    }
    if ( [prefs boolForKey:@"useMonospacedFonts"] ) {
        [useMonospacedFontsSwitch setState:NSOnState];
    } else {
        [useMonospacedFontsSwitch setState:NSOffState];
    }
    if ( [prefs boolForKey:@"fetchRowCount"] ) {
        [fetchRowCountSwitch setState:NSOnState];
    } else {
        [fetchRowCountSwitch setState:NSOffState];
    }
    if ( [prefs boolForKey:@"SUCheckAtStartup"] ) {
        [checkForUpdatesOnStartup setState:NSOnState];
    } else {
        [checkForUpdatesOnStartup setState:NSOffState];
    }
    [nullValueField setStringValue:[prefs stringForKey:@"nullValue"]];
    [limitRowsField setStringValue:[prefs stringForKey:@"limitRowsValue"]];
    [self chooseLimitRows:self];
    [encodingPopUpButton selectItemWithTitle:[prefs stringForKey:@"encoding"]];

    [preferencesWindow makeKeyAndOrderFront:self];
}

- (IBAction)addFavorite:(id)sender
/*
adds a favorite
*/
{
    int code;

    isNewFavorite = YES;

    [nameField setStringValue:@""];
    [hostField setStringValue:@""];
    [socketField setStringValue:@""];
    [userField setStringValue:@""];
    [passwordField setStringValue:@""];
    [portField setStringValue:@""];
    [databaseField setStringValue:@""];
	
    [NSApp beginSheet:favoriteSheet
            modalForWindow:preferencesWindow modalDelegate:self
            didEndSelector:nil contextInfo:nil];
    code = [NSApp runModalForWindow:favoriteSheet];
    
    [NSApp endSheet:favoriteSheet];
    [favoriteSheet orderOut:nil];
    
    if ( code == 1 ) {
        if ( ![[socketField stringValue] isEqualToString:@""] ) {
        //set host to localhost if socket is used
            [hostField setStringValue:@"localhost"];
        }
        NSDictionary *favorite = [NSDictionary
                dictionaryWithObjects:[NSArray arrayWithObjects:[nameField stringValue], [hostField stringValue], [socketField stringValue], [userField stringValue], [portField stringValue], [databaseField stringValue], nil]
                forKeys:[NSArray arrayWithObjects:@"name", @"host", @"socket", @"user", @"port", @"database", nil]];
        [favorites addObject:favorite];
        if ( ![[passwordField stringValue] isEqualToString:@""] )
            [keyChainInstance addPassword:[passwordField stringValue]
                forName:[NSString stringWithFormat:@"Shift : %@", [nameField stringValue]]
                account:[NSString stringWithFormat:@"%@@%@/%@", [userField stringValue], [hostField stringValue],
                    [databaseField stringValue]]];
        [tableView reloadData];
        [tableView selectRow:[tableView numberOfRows]-1 byExtendingSelection:NO];
    }
    
    isNewFavorite = NO;
}

- (IBAction)removeFavorite:(id)sender
/*
removes a favorite
*/
{
    if ( ![tableView numberOfSelectedRows] )
        return;

    NSString *name = [[favorites objectAtIndex:[tableView selectedRow]] objectForKey:@"name"];
    NSString *user = [[favorites objectAtIndex:[tableView selectedRow]] objectForKey:@"user"];
    NSString *host = [[favorites objectAtIndex:[tableView selectedRow]] objectForKey:@"host"];
    NSString *database = [[favorites objectAtIndex:[tableView selectedRow]] objectForKey:@"database"];
    [keyChainInstance deletePasswordForName:[NSString stringWithFormat:@"Shift : %@", name]
            account:[NSString stringWithFormat:@"%@@%@/%@", user, host, database]];
    [favorites removeObjectAtIndex:[tableView selectedRow]];
    [tableView reloadData];
}

- (IBAction)copyFavorite:(id)sender
/*
copies a favorite
*/
{
    if ( ![tableView numberOfSelectedRows] )
        return;
        
    NSMutableDictionary *tempDictionary = [NSMutableDictionary dictionaryWithDictionary:[favorites objectAtIndex:[tableView selectedRow]]];
    [tempDictionary setObject:[NSString stringWithFormat:@"%@Copy", [tempDictionary objectForKey:@"name"]] forKey:@"name"];
//    [tempDictionary setObject:[NSString stringWithFormat:@"%@Copy", [tempDictionary objectForKey:@"user"]] forKey:@"user"];

    [favorites insertObject:tempDictionary atIndex:[tableView selectedRow]+1];
    [tableView selectRow:[tableView selectedRow]+1 byExtendingSelection:NO];

    [tableView reloadData];
}

- (IBAction)chooseLimitRows:(id)sender
/*
enables or disables limitRowsField (depending on the state of limitRowsSwitch)
*/
{
    if ( [limitRowsSwitch state] == NSOnState ) {
        [limitRowsField setEnabled:YES];
        [limitRowsField selectText:self];
    } else {
        [limitRowsField setEnabled:NO];
    }
}

- (IBAction)closeFavoriteSheet:(id)sender
/*
close the favoriteSheet and save favorite if user hit save
*/
{
    NSEnumerator *enumerator = [favorites objectEnumerator];
    id favorite;
    int count;

//test if user has entered at least name and host/socket
    if ( [sender tag] &&
            ([[nameField stringValue] isEqualToString:@""] ||
                    ([[hostField stringValue] isEqualToString:@""] && [[socketField stringValue] isEqualToString:@""])) ) {
        NSRunAlertPanel(NSLocalizedString(@"Error", @"error"), NSLocalizedString(@"Please enter at least name and host or socket!", @"message of panel when name/host/socket are missing"), NSLocalizedString(@"OK", @"OK button"), nil, nil);
        return;
    }
    
//test if favorite name isn't used by another favorite
    count = 0;
    if ( [sender tag] ) {
        while ( (favorite = [enumerator nextObject]) ) {
            if ( [[favorite objectForKey:@"name"] isEqualToString:[nameField stringValue]] )
            {
                if ( isNewFavorite || (!isNewFavorite && (count != [tableView selectedRow])) ) {
                    NSRunAlertPanel(NSLocalizedString(@"Error", @"error"), [NSString stringWithFormat:NSLocalizedString(@"Favorite %@ has already been saved!\nPlease specify another name.", @"message of panel when favorite name has already been used"), [nameField stringValue]], NSLocalizedString(@"OK", @"OK button"), nil, nil);
                    return;
                }
            }
/*
            if ( [[favorite objectForKey:@"host"] isEqualToString:[hostField stringValue]] &&
                    [[favorite objectForKey:@"user"] isEqualToString:[userField stringValue]] &&
                    [[favorite objectForKey:@"database"] isEqualToString:[databaseField stringValue]] ) {
                if ( isNewFavorite || (!isNewFavorite && (count != [tableView selectedRow])) ) {
                    NSRunAlertPanel(@"Error", @"There is already a favorite with the same host, user and database!", @"OK", nil, nil);
                    return;
                }
            }
*/
            count++;
        }
    }

    [NSApp stopModalWithCode:[sender tag]];
}

//services menu methods
- (void)doPerformQueryService:(NSPasteboard *)pboard userData:(NSString *)data error:(NSString **)error
/*
passes the query to the last created document
*/
{
    NSString *pboardString;
    NSArray *types;

    types = [pboard types];

    if (![types containsObject:NSStringPboardType] || !(pboardString = [pboard stringForType:NSStringPboardType])) {
        *error = @"Pasteboard couldn't give string.";
        return;
    }

//check if there exists a document
    if ( ![[[NSDocumentController sharedDocumentController] documents] count] ) {
        *error = @"No Documents open!";
        return;
    }

//pass query to last created document
//    [[[NSDocumentController sharedDocumentController] currentDocument] doPerformQueryService:pboardString];
    [[[[NSDocumentController sharedDocumentController] documents] objectAtIndex:[[[NSDocumentController sharedDocumentController] documents] count]-1] doPerformQueryService:pboardString];

    return;
}

//menu methods
- (IBAction)visitWebsite:(id)sender
/*
opens donate link in default browser
*/
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://www.shiftosx.com/"]];
}

- (IBAction)visitHelpWebsite:(id)sender
/*
opens donate link in default browser
*/
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://www.shiftosx.com/help"]];
}

//tableView datasource methods
- (int)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return [favorites count];
}

- (id)tableView:(NSTableView *)aTableView
            objectValueForTableColumn:(NSTableColumn *)aTableColumn
            row:(int)rowIndex
{
	return [[favorites objectAtIndex:rowIndex] objectForKey:[aTableColumn identifier]];
}


//tableView drag&drop datasource methods
- (BOOL)tableView:(NSTableView *)tv writeRows:(NSArray*)rows toPasteboard:(NSPasteboard*)pboard
{
    int originalRow;
    NSArray *pboardTypes;

    if ( [rows count] == 1 ) {
        pboardTypes=[NSArray arrayWithObjects:@"ShiftPreferencesPasteboard", nil];
        originalRow = [[rows objectAtIndex:0] intValue];

	[pboard declareTypes:pboardTypes owner:nil];
	[pboard setString:[[NSNumber numberWithInt:originalRow] stringValue] forType:@"ShiftPreferencesPasteboard"];

        return YES;
    } else {
        return NO;
    }
}

- (NSDragOperation)tableView:(NSTableView*)tv validateDrop:(id <NSDraggingInfo>)info proposedRow:(int)row
    proposedDropOperation:(NSTableViewDropOperation)operation
{
    NSArray *pboardTypes = [[info draggingPasteboard] types];
    int originalRow;

    if ([pboardTypes count] == 1 && row != -1)
    {
        if ([[pboardTypes objectAtIndex:0] isEqualToString:@"ShiftPreferencesPasteboard"]==YES && operation==NSTableViewDropAbove)
        {
            originalRow = [[[info draggingPasteboard] stringForType:@"ShiftPreferencesPasteboard"] intValue];

            if (row != originalRow && row != (originalRow+1))
            {
                return NSDragOperationMove;
            }
        }
    }

    return NSDragOperationNone;
}

- (BOOL)tableView:(NSTableView*)tv acceptDrop:(id <NSDraggingInfo>)info row:(int)row dropOperation:(NSTableViewDropOperation)operation
{
    int originalRow;
    int destinationRow;
    NSMutableDictionary *draggedRow;

    originalRow = [[[info draggingPasteboard] stringForType:@"ShiftPreferencesPasteboard"] intValue];
    destinationRow = row;

    if ( destinationRow > originalRow )
        destinationRow--;

    draggedRow = [NSMutableDictionary dictionaryWithDictionary:[favorites objectAtIndex:originalRow]];
    [favorites removeObjectAtIndex:originalRow];
    [favorites insertObject:draggedRow atIndex:destinationRow];
    
    [tableView reloadData];
    [tableView selectRow:destinationRow byExtendingSelection:NO];

    return YES;
}

- (BOOL)tableView:(NSTableView *)aTableView shouldEditTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex
/*
opens sheet to edit favorite and saves favorite if user hit OK
*/
{
    int code;
    NSDictionary *favorite = [favorites objectAtIndex:rowIndex];

// set up fields
    [nameField setStringValue:[favorite objectForKey:@"name"]];
    [hostField setStringValue:[favorite objectForKey:@"host"]];
    [socketField setStringValue:[favorite objectForKey:@"socket"]];
    [userField setStringValue:[favorite objectForKey:@"user"]];
    [portField setStringValue:[favorite objectForKey:@"port"]];
    [databaseField setStringValue:[favorite objectForKey:@"database"]];
    [passwordField setStringValue:[keyChainInstance
        getPasswordForName:[NSString stringWithFormat:@"Shift : %@", [nameField stringValue]]
        account:[NSString stringWithFormat:@"%@@%@/%@", [userField stringValue], [hostField stringValue],
                    [databaseField stringValue]]]];


// run sheet
    [NSApp beginSheet:favoriteSheet
            modalForWindow:preferencesWindow modalDelegate:self
            didEndSelector:nil contextInfo:nil];
    code = [NSApp runModalForWindow:favoriteSheet];

    [NSApp endSheet:favoriteSheet];
    [favoriteSheet orderOut:nil];

    if ( code == 1 ) {
        if ( ![[socketField stringValue] isEqualToString:@""] ) {
        //set host to localhost if socket is used
            [hostField setStringValue:@"localhost"];
        }
//replace password
        [keyChainInstance deletePasswordForName:[NSString stringWithFormat:@"Shift : %@", [favorite objectForKey:@"name"]]
                account:[NSString stringWithFormat:@"%@@%@/%@", [favorite objectForKey:@"user"],
                    [favorite objectForKey:@"host"], [favorite objectForKey:@"database"]]];
        if ( ![[passwordField stringValue] isEqualToString:@""] )
            [keyChainInstance addPassword:[passwordField stringValue]
                forName:[NSString stringWithFormat:@"Shift : %@", [nameField stringValue]]
                account:[NSString stringWithFormat:@"%@@%@/%@", [userField stringValue], [hostField stringValue],
                            [databaseField stringValue]]];
//replace favorite
        favorite = [NSDictionary
                dictionaryWithObjects:[NSArray arrayWithObjects:[nameField stringValue], [hostField stringValue], [socketField stringValue], [userField stringValue], [portField stringValue], [databaseField stringValue], nil]
                forKeys:[NSArray arrayWithObjects:@"name", @"host", @"socket", @"user", @"port", @"database", nil]];
        [favorites replaceObjectAtIndex:rowIndex withObject:favorite];
        [tableView reloadData];
    }

    return NO;
}


//window delegate methods
- (BOOL)windowShouldClose:(id)sender
/*
saves the preferences
*/
{
    if ( sender == preferencesWindow ) {
        if ( [reloadAfterAddingSwitch state] == NSOnState ) {
            [prefs setBool:YES forKey:@"reloadAfterAdding"];
        } else {
            [prefs setBool:NO forKey:@"reloadAfterAdding"];
        }
        if ( [reloadAfterEditingSwitch state] == NSOnState ) {
            [prefs setBool:YES forKey:@"reloadAfterEditing"];
        } else {
            [prefs setBool:NO forKey:@"reloadAfterEditing"];
        }
        if ( [reloadAfterRemovingSwitch state] == NSOnState ) {
            [prefs setBool:YES forKey:@"reloadAfterRemoving"];
        } else {
            [prefs setBool:NO forKey:@"reloadAfterRemoving"];
        }
        if ( [showErrorSwitch state] == NSOnState ) {
            [prefs setBool:YES forKey:@"showError"];
        } else {
            [prefs setBool:NO forKey:@"showError"];
        }
        if ( [dontShowBlobSwitch state] == NSOnState ) {
            [prefs setBool:YES forKey:@"dontShowBlob"];
        } else {
            [prefs setBool:NO forKey:@"dontShowBlob"];
        }
        if ( [limitRowsSwitch state] == NSOnState ) {
            [prefs setBool:YES forKey:@"limitRows"];
        } else {
            [prefs setBool:NO forKey:@"limitRows"];
        }
        if ( [useMonospacedFontsSwitch state] == NSOnState ) {
            [prefs setBool:YES forKey:@"useMonospacedFonts"];
        } else {
            [prefs setBool:NO forKey:@"useMonospacedFonts"];
        }
        if ( [fetchRowCountSwitch state] == NSOnState ) {
            [prefs setBool:YES forKey:@"fetchRowCount"];
        } else {
            [prefs setBool:NO forKey:@"fetchRowCount"];
        }
        [prefs setObject:[nullValueField stringValue] forKey:@"nullValue"];
        if ( [limitRowsField intValue] > 0 ) {
            [prefs setInteger:[limitRowsField intValue] forKey:@"limitRowsValue"];
        } else {
            [prefs setInteger:1 forKey:@"limitRowsValue"];    
        }
		if ([checkForUpdatesOnStartup state] == NSOnState){
			[prefs setBool:YES forKey:@"SUCheckAtStartup"];
		} else{
			[prefs setBool:NO forKey:@"SUCheckAtStartup"];
		}
        [prefs setObject:[encodingPopUpButton titleOfSelectedItem] forKey:@"encoding"];
    
        [prefs setObject:favorites forKey:@"favorites"];
    }
    return YES;
}


//other methods
- (void)awakeFromNib
/*
code that need to be executed when the nib file is loaded
*/
{
//register MainController as services provider
    [NSApp setServicesProvider:self];

    prefs = [[NSUserDefaults standardUserDefaults] retain];
    isNewFavorite = NO;

//set standard preferences if no preferences are found
    if ( [prefs objectForKey:@"reloadAfterAdding"] == nil )
    {
        [prefs setObject:@"0.1" forKey:@"version"];
        [prefs setBool:YES forKey:@"reloadAfterAdding"];
        [prefs setBool:YES forKey:@"reloadAfterEditing"];
        [prefs setBool:NO forKey:@"reloadAfterRemoving"];
        [prefs setObject:@"NULL" forKey:@"nullValue"];
        [prefs setObject:@"Autodetect" forKey:@"encoding"];
        [prefs setBool:YES forKey:@"fetchRowCount"];
        [prefs setBool:NO forKey:@"useMonospacedFonts"];
		NSMutableArray *tempFavorites = [NSMutableArray array];
		[prefs setObject:tempFavorites forKey:@"favorites"];
        [prefs setBool:YES forKey:@"showError"];
        [prefs setBool:NO forKey:@"dontShowBlob"];
        [prefs setBool:NO forKey:@"limitRows"];
        [prefs setInteger:100 forKey:@"limitRowsValue"];
    }

    [tableView registerForDraggedTypes:[NSArray arrayWithObjects:@"ShiftPreferencesPasteboard", nil]];
    [tableView reloadData];
}

@end
