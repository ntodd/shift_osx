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

@interface BaseNode : NSObject <NSCoding, NSCopying>
{
	NSString		* title;
	NSString		* toolTip;
	NSString		* type;
	NSMutableArray	* children;
	BOOL			  isLeaf;
	NSImage			* nodeIcon; //not used right now, but could be used
}

@property (retain) NSString        *title;
@property (retain) NSString        *toolTip;
@property (retain) NSString        *type;
@property (retain) NSMutableArray  *children;
@property (retain) NSImage         *nodeIcon;
@property          BOOL             isLeaf;


- (id)initLeaf;
- (id)initFromFavorite:(NSDictionary*)favorite;
- (id)initWithTitle:(NSString *)nodeTitle andType:(NSString *)nodeType;

- (BOOL)isDraggable;

- (NSComparisonResult)compare:(BaseNode*)aNode;

- (NSArray*)mutableKeys;

- (NSDictionary*)dictionaryRepresentation;
- (id)initWithDictionary:(NSDictionary*)dictionary;

- (void)appendChild:(BaseNode*)child;
- (id)parentFromArray:(NSArray*)array;
- (void)removeObjectFromChildren:(id)obj;
- (NSArray*)descendants;
- (NSArray*)allChildLeafs;
- (NSArray*)groupChildren;
- (BOOL)isDescendantOfOrOneOfNodes:(NSArray*)nodes;
- (BOOL)isDescendantOfNodes:(NSArray*)nodes;
- (NSIndexPath*)indexPathInArray:(NSArray*)array;

@end
