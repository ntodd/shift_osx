/* 
 * Shift is the legal property of its developers, whose names are listed in the copyright file included
 * with this source distribution.
 * 
 * This program is free software; you can redistribute it and/or modify it under the terms of the GNU
 * General Public License as published by the Free Software Foundation; either version 3 of the License,
 * or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even
 * the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General
 * Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License along with this program; if not,
 * write to the Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA 
 * or see <http://www.gnu.org/licenses/>.
 */

#import <Cocoa/Cocoa.h>
#import "BaseNode.h"
#import "ConsoleView.h"
#import "AboutBoxController.h"
#import "PreferenceWindowController.h"

@interface ShiftWindowController : NSWindowController {
	IBOutlet NSOutlineView *serverOutline;
	IBOutlet NSSplitView *contentSplitView;
	IBOutlet NSImageView *splitResizeControl;
	
	IBOutlet ConsoleView *consoleView;
	
	NSMutableArray *contents;
	
	NSImage *serverImage;
	
	NSUserDefaults *prefs;
	NSMutableArray *favorites;
	BaseNode *root;
}

@property (retain) NSMutableArray * contents;

- (NSMutableArray*)contents;

- (IBAction)toggleSourceItem:(id)sender;
- (IBAction)toggleConsole:(id)sender;

- (IBAction)showAboutBox:(id)sender;
- (IBAction)showPreferencesWindow:(id)sender;

- (void)reloadServerList;

@end
