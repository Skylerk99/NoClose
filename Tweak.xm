@interface SBDeckSwitcherViewController
{
	NSMutableArray *_displayItems;
}
@property(retain, nonatomic) NSArray *displayItems; // @synthesize displayItems=_displayItems;
- (void)_layoutDisplayItem:(id)arg1;
-(void)setDisplayItems:(NSArray*)items;
-(void)killDisplayItemOfContainer:(id)arg1 withVelocity:(CGFloat)arg2;
-(id)_itemContainerForDisplayItem:(id)arg1;
@end

@interface SBDisplayItem : NSObject
@property (nonatomic,readonly) NSString* displayIdentifier;
@end

@interface SBDeckSwitcherItemContainer
@property(readonly, retain, nonatomic) SBDisplayItem *displayItem;
- (void)_handlePageViewTap:(id)arg1;
@end

@interface SBApplication : NSObject
- (NSString *)displayIdentifier;
@end

@interface SBMediaController : NSObject
+ (id)sharedInstance;
- (BOOL)isPlaying;
- (NSDictionary *)_nowPlayingInfo;
- (SBApplication *)nowPlayingApplication;
@end




SBDisplayItem *selected;
static BOOL Showing = NO;
SBDisplayItem *now = nil;
SBDeckSwitcherItemContainer *killed;
UIActionSheet* actionSheet_2;
SBMediaController *mediaController = [objc_getClass("SBMediaController") sharedInstance];




%hook SBDeckSwitcherViewController
- (_Bool)isDisplayItemOfContainerRemovable:(SBDeckSwitcherItemContainer *)arg1
{
	now = [arg1 displayItem];

	if (now.displayIdentifier == [[mediaController nowPlayingApplication] displayIdentifier])
	{
		return NO;
	}
	else
	{
		return %orig;
	}
}


-(void)scrollViewKillingProgressUpdated:(CGFloat)arg1 ofContainer:(SBDeckSwitcherItemContainer *)arg2 {

	%orig;
	selected = [arg2 displayItem];
	killed = arg2;

	if ((arg1 > 0.2) && (selected.displayIdentifier == [[mediaController nowPlayingApplication] displayIdentifier]) && (Showing == NO))
	{
		UIAlertView *actionSheet_2 = [[UIAlertView alloc] 	/*should really change this since UIAlertView is depricated but too lazy for now*/
									  initWithTitle:@"Are you sure you'd like to close the now playing app?"
									  message:@""
									  delegate:self
									  cancelButtonTitle:@"No, Keep"
									  otherButtonTitles:@"Yes, Close", nil];
		[actionSheet_2 show];
		[actionSheet_2 release];
		Showing = YES;
	}
}


%new
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	Showing = NO;
	actionSheet_2 = nil;

	if(buttonIndex == 1)
	{
		[self killDisplayItemOfContainer:killed withVelocity:1.0];
	}
}
%end


