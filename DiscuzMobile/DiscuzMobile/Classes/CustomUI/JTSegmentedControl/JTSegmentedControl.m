//
//  JTSegmentedControl.m
//  Test_Segment
//
//  Created by HB on 17/1/12.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "JTSegmentedControl.h"
#import "JTSegmentedCell.h"

@interface JTSegmentedControl()<UIGestureRecognizerDelegate>

@property (nonatomic, assign) CGRect initialIndicatorViewFrame;
@property (nonatomic, assign) NSInteger oldNearestIndex;

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;

@end

@implementation JTSegmentedControl

- (instancetype)init {
    if (self = [super init]) {
        [self commitInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commitInit];
    }
    return self;
}

- (void)add:(JTSegmentedCell *)cell {
    cell.userInteractionEnabled = NO;
    [self.cells addObject:cell];
    [self addSubview:cell];
    self.selectedIndex = self.defaultSelectedIndex;
}

- (void)addWithArry:(NSArray<JTSegmentedCell *> *)cells {
    for (JTSegmentedCell *cell in cells) {
        cell.userInteractionEnabled = NO;
        [self.cells addObject:cell];
        [self addSubview:cell];
        self.selectedIndex = self.defaultSelectedIndex;
    }
}

- (void)commitInit {
    self.defaultSelectedIndex = 0;
    self.isUpdateToNearestIndexWhenDrag = YES;
    self.selectedIndex = 0;
    self.isScrollEnabled = YES;
    self.isSwipeEnabled = YES;
    self.isRoundedFrame = YES;
    self.roundedRelativeFactor = 0.5;
    
    self.layer.masksToBounds = YES;
    
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    self.panGestureRecognizer.delegate = self;
    [self addGestureRecognizer:self.panGestureRecognizer];
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 2;
    
    self.indicatorView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.indicatorView];
    
    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipe:)];
    self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    self.leftSwipeGestureRecognizer.delegate = self;
    [self.indicatorView addGestureRecognizer:self.leftSwipeGestureRecognizer];
    
    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipe:)];
    self.rightSwipeGestureRecognizer.delegate = self;
    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.indicatorView addGestureRecognizer:self.rightSwipeGestureRecognizer];
    
    
    
    [self addObserver:self forKeyPath:@"selectedIndex" options:(NSKeyValueObservingOptionNew) context:nil];
    [self addObserver:self forKeyPath:@"isScrollEnabled" options:(NSKeyValueObservingOptionNew) context:nil];
    [self addObserver:self forKeyPath:@"isSwipeEnabled" options:(NSKeyValueObservingOptionNew) context:nil];
    [self addObserver:self forKeyPath:@"isRoundedFrame" options:(NSKeyValueObservingOptionNew) context:nil];
    [self addObserver:self forKeyPath:@"roundedRelativeFactor" options:(NSKeyValueObservingOptionNew) context:nil];
    
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"selectedIndex" context:nil];
    [self removeObserver:self forKeyPath:@"isScrollEnabled" context:nil];
    [self removeObserver:self forKeyPath:@"isSwipeEnabled" context:nil];
    [self removeObserver:self forKeyPath:@"isRoundedFrame" context:nil];
    [self removeObserver:self forKeyPath:@"roundedRelativeFactor" context:nil];
}

- (void)pan:(UIPanGestureRecognizer *)sender {
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.initialIndicatorViewFrame = self.indicatorView.frame;
            self.oldNearestIndex = [self nearestIndexToPoint:self.indicatorView.center];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGRect frame = self.initialIndicatorViewFrame;
            frame.origin.x += [sender translationInView:self].x;
            self.indicatorView.frame = frame;
            if (self.indicatorView.frame.origin.x < 0) {
                frame = self.indicatorView.frame;
                frame.origin.x = 0;
                self.indicatorView.frame = frame;
            }
            if (self.indicatorView.frame.origin.x + self.indicatorView.frame.size.width > self.frame.size.width) {
                frame = self.indicatorView.frame;
                frame.origin.x = self.frame.size.width - self.indicatorView.frame.size.width;
                self.indicatorView.frame = frame;
                
            }
            if (self.isUpdateToNearestIndexWhenDrag) {
                NSInteger nearestIndex = [self nearestIndexToPoint:self.indicatorView.center];
                if (self.oldNearestIndex != nearestIndex && self.delegate != nil) {
                    self.oldNearestIndex = [self nearestIndexToPoint:self.indicatorView.center];
                    if ([self.delegate respondsToSelector:@selector(normalState:forIndex:)]) {
                        int i = 0;
                        for (JTSegmentedCell *cell in self.cells) {
                            [self.delegate normalState:cell forIndex:i];
                            i ++;
                        }
                    }
                    
                    if ([self.delegate respondsToSelector:@selector(selectedState:forIndex:)]) {
                        [self.delegate selectedState:self.cells[nearestIndex] forIndex:nearestIndex];
                    }
                    
                    [self.delegate indicatorViewRelativePostion:self.indicatorView.frame.origin.x andSegmentControl:self];
                }
            }
        }
            break;
            
            case UIGestureRecognizerStateEnded:
            
            case UIGestureRecognizerStateFailed:

        case UIGestureRecognizerStateCancelled:
        {
            [self endDo:sender];
        }
            break;

        default:
            break;
    }
}

- (void)endDo:(UIPanGestureRecognizer *)sender {
    CGFloat translation = [sender translationInView:self].x;
    if (fabs(translation) > (self.frame.size.width / self.cells.count * 0.08)) {
        if (self.selectedIndex == [self nearestIndexToPoint:self.indicatorView.center]) {
            if (translation > 0) {
                self.selectedIndex = self.selectedIndex + 1;
            } else {
                self.selectedIndex = self.selectedIndex - 1;
            }
        } else {
            self.selectedIndex = [self nearestIndexToPoint:self.indicatorView.center];
        }
    } else {
        self.selectedIndex = [self nearestIndexToPoint:self.indicatorView.center];
    }
}

- (void)leftSwipe:(UISwipeGestureRecognizer *)sender {
    switch (sender.state) {
        case UIGestureRecognizerStateEnded:
            self.selectedIndex = self.selectedIndex - 1;
            break;
            
        default:
            break;
    }
}

- (void)rightSwipe:(UISwipeGestureRecognizer *)sender {
    switch (sender.state) {
        case UIGestureRecognizerStateEnded:
            self.selectedIndex = self.selectedIndex + 1;
            break;
            
        default:
            break;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.panGestureRecognizer  ) {
        CGPoint local = [gestureRecognizer locationInView:self];
        
        return [self isInSuperView:self.indicatorView.frame andPoint:local];

    }
    return [super gestureRecognizerShouldBegin:gestureRecognizer];
}

- (void)updateSelectedIndex:(BOOL)animated {
    if (self.delegate != nil) {
        int i = 0;
        if ([self.delegate respondsToSelector:@selector(normalState:forIndex:)]) {
            for (JTSegmentedCell *cell in self.cells) {
                [self.delegate normalState:cell forIndex:i];
                i ++;
            }
        }
        if ([self.delegate respondsToSelector:@selector(selectedState:forIndex:)]) {
            [self.delegate selectedState:self.cells[self.selectedIndex] forIndex:self.selectedIndex];
        }
    }
    [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.indicatorView.frame = self.cells[self.selectedIndex].frame;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.isRoundedFrame) {
        self.layer.cornerRadius = MIN(self.frame.size.width, self.frame.size.height) * self.roundedRelativeFactor;
        self.indicatorView.layer.cornerRadius = self.layer.cornerRadius;
    }
    
    if (self.cells.count == 0) {
        return;
    }
    CGFloat cellWidth = self.frame.size.width / self.cells.count;
    int i = 0;
    for (JTSegmentedCell *cell in self.cells) {
        cell.frame = CGRectMake(cellWidth * i, 0, cellWidth, self.frame.size.height);
        i ++;
    }
    self.indicatorView.frame = CGRectMake(0, 0, cellWidth, self.frame.size.height);
    [self updateSelectedIndex:YES];
    
}

- (NSInteger)nearestIndexToPoint:(CGPoint)point {
    NSInteger min = 100;
    
    int i = 0;
    int temp = 0;
    for (JTSegmentedCell *cell in self.cells) {
        if (min > [[NSString stringWithFormat:@"%f",fabs(point.x - cell.center.x)] intValue]){
            min = [[NSString stringWithFormat:@"%f",fabs(point.x - cell.center.x)] intValue];
            temp = i;
        }
        i ++;
    }
    return temp;
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    NSLog(@"点击了Tracking");
    CGPoint location = [touch locationInView:self];
    
    NSInteger calculatedIndex = 0;
    BOOL isSelect = NO;
    int i = 0;
    
    for (JTSegmentedCell *cell in self.cells) {
        if ([self isInSuperView:cell.frame andPoint:location]) {
            calculatedIndex = i;
            isSelect = YES;
        }
        i ++;
    }
    if (isSelect) {
        self.selectedIndex = calculatedIndex;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
    return NO;
}

- (BOOL)isInSuperView:(CGRect)superFrame andPoint:(CGPoint)point {
    CGMutablePathRef pathRef=CGPathCreateMutable();
    CGPathMoveToPoint(pathRef, NULL, CGRectGetMinX(superFrame), CGRectGetMinY(superFrame));
    CGPathAddLineToPoint(pathRef, NULL, CGRectGetMinX(superFrame), CGRectGetMaxY(superFrame));
    CGPathAddLineToPoint(pathRef, NULL, CGRectGetMaxX(superFrame), CGRectGetMaxY(superFrame));
    CGPathAddLineToPoint(pathRef, NULL, CGRectGetMaxX(superFrame), CGRectGetMinY(superFrame));
    CGPathAddLineToPoint(pathRef, NULL, CGRectGetMinX(superFrame), CGRectGetMinY(superFrame));
    CGPathCloseSubpath(pathRef);
    
    return CGPathContainsPoint(pathRef, NULL, point,NO);
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"isRoundedFrame"] || [keyPath isEqualToString:@"roundedRelativeFactor"]) {
        [self layoutIfNeeded];
    } else if ([keyPath isEqualToString:@"selectedIndex"]) {
        if (self.selectedIndex < 0) {
            self.selectedIndex = 0;
        }
        if (self.selectedIndex >= self.cells.count) {
            self.selectedIndex = self.cells.count - 1;
        }
        [self updateSelectedIndex:NO];
        
    } else if ([keyPath isEqualToString:@"isScrollEnabled"]) {
        self.panGestureRecognizer.enabled = self.isScrollEnabled;
    } else if ([keyPath isEqualToString:@"isSwipeEnabled"]) {
        self.leftSwipeGestureRecognizer.enabled = self.isSwipeEnabled;
        self.rightSwipeGestureRecognizer.enabled = self.isSwipeEnabled;
    }
}

- (UIView *)indicatorView {
    if (_indicatorView == nil) {
        _indicatorView = [[UIView alloc] init];
    }
    return _indicatorView;
}

- (NSMutableArray<JTSegmentedCell *> *)cells {
    if (!_cells) {
        _cells = [NSMutableArray array];
    }
    return _cells;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
