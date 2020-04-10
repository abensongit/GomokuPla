
#import "JSLCheckerBoardView.h"

NSInteger const CHECKER_BOARD_SIZE_N08 = 8;
NSInteger const CHECKER_BOARD_SIZE_N10 = 10;
NSInteger const CHECKER_BOARD_SIZE_N12 = 12;
NSInteger const CHECKER_BOARD_SIZE_N14 = 14;

@interface JSLCheckerBoardView () {
    CGFloat _margin;  // 棋盘边距
    CGFloat _interval;  // 网格间距
    NSInteger _board_size;  // 棋盘大小（8/10/12/14）
    UIImageView *_indicatorView; // 下棋指示器
    NSMutableArray *_imageViews; // 黑白棋子图
}
@end

@implementation JSLCheckerBoardView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initializeSettings];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initializeSettings];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeSettings];
    }
    return self;
}

- (void)initializeSettings
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tap];
    
    _imageViews = [NSMutableArray array];
    _indicatorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_chess_indicator"]];
}

- (void)reset
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_imageViews removeAllObjects];
}

- (void)handleTap:(UITapGestureRecognizer *)tapGestureRecognizer
{
    CGPoint location = [tapGestureRecognizer locationInView:self];
    
    JSLPoint point = [self findPointWithLocation:location];
    
    [self.delegate boardView:self didTapOnPoint:point];
}

- (JSLPoint)findPointWithLocation:(CGPoint)location
{
    int row = (int)((location.y - _margin) / _interval);
    double modY = (location.y - _margin) / _interval - row;
    if(modY > 0.5 && row < _board_size) {
        row ++;
    }
    
    int column = (int)((location.x - _margin) / _interval);
    double modX = (location.x - _margin) / _interval - column;
    if(modX > 0.5 && column < _board_size) {
        column ++;
    }
    
    JSLPoint point;
    point.i = row;
    point.j = column;
    JSLLog(@"[%d, %d]", row, column);
    
    return point;
}

- (void)insertPieceAtPoint:(JSLPoint)point playerType:(JSLPlayerType)playerType
{
    NSString *imageName;
    if (JSLPlayerTypeBlack == playerType) {
        imageName = ICON_GOMOKU_PIECE_BLACK;
    } else {
        imageName = ICON_GOMOKU_PIECE_WHITE;
    }
    
    CGFloat imageSize = _interval*0.95f;
    CGFloat pieceImageOriginX = _margin + point.j * _interval - imageSize / 2 - imageSize*0.07f;
    CGFloat pieceImageOriginY = _margin + point.i * _interval - imageSize / 2 - imageSize*0.07f;
    CGRect pieceImageRect = CGRectMake(pieceImageOriginX, pieceImageOriginY, imageSize, imageSize);
    
    UIImageView *pieceImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    pieceImage.frame = pieceImageRect;
    [_imageViews addObject:pieceImage];
    [self addSubview:pieceImage];
    
    CGFloat indicatorViewOriginX = _margin + point.j * _interval - _interval / 2.0f;
    CGFloat indicatorViewOriginY = _margin + point.i * _interval - _interval / 2.0f;
    CGRect indicatorViewrect = CGRectMake(indicatorViewOriginX, indicatorViewOriginY, _interval, _interval);
    _indicatorView.frame = indicatorViewrect;
    if (_indicatorView.superview != self) {
        [self addSubview:_indicatorView];
    }
}

- (void)removeImageWithCount:(int)count
{
    for (int i = 0; i < count; i++) {
        UIImageView *imageView = [_imageViews lastObject];
        [imageView removeFromSuperview];
        imageView = nil;
        [_imageViews removeLastObject];
    }
    UIImageView *imageView = [_imageViews lastObject];
    if (imageView != nil) {
        _indicatorView.frame = imageView.frame;
    } else {
        [_indicatorView removeFromSuperview];
    }
}

- (void)drawRect:(CGRect)rect
{
    // 背景图片
    UIImage *background = [UIImage imageNamed:@"icon_checker_board"];
    [background drawInRect:rect];
    
    // 棋盘边框
    CGRect borderRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.height, rect.size.width);
    UIBezierPath *border = [UIBezierPath bezierPathWithRoundedRect:borderRect cornerRadius:0];
    [border setLineWidth:8.0f];
    [[UIColor blackColor] setStroke];
    [border stroke];
    
    // 棋盘变量
    _margin = 15.0f; // 棋盘边距
    _board_size = APPINFORMATION.checkerBoardSize.integerValue; // 棋盘大小
    _interval = ((self.bounds.size.width - _margin * 2) / _board_size); // 网格间距
    CGFloat borderLineWidth = 2; // 棋盘边宽
    CGFloat insideLineWidth = 1; // 网络线宽
    
    // 创建棋盘
    for (int i = 0; i < _board_size + 1 ; i++) {
        UIBezierPath *horizontalLine = [[UIBezierPath alloc] init];
        UIBezierPath *verticalLine = [[UIBezierPath alloc] init];
        
        if (i == 0 || i == _board_size) {
            [horizontalLine moveToPoint:CGPointMake(_margin - 1, _interval * i + _margin)];
            [verticalLine moveToPoint:CGPointMake(_interval * i + _margin, _margin)];
            
            [horizontalLine addLineToPoint:CGPointMake(_margin + _interval * _board_size + 1, _interval * i + _margin)];
            [verticalLine addLineToPoint:CGPointMake(_interval * i + _margin, _margin + _interval * _board_size)];
            
            horizontalLine.lineWidth = borderLineWidth;
            verticalLine.lineWidth  = borderLineWidth;
        } else {
            [horizontalLine moveToPoint:CGPointMake(_margin, _interval * i + _margin)];
            [verticalLine moveToPoint:CGPointMake(_interval * i + _margin, _margin)];
            
            [horizontalLine addLineToPoint:CGPointMake(_margin + _interval * _board_size, _interval * i + _margin)];
            [verticalLine addLineToPoint:CGPointMake(_interval * i + _margin, _margin + _interval * _board_size)];
            
            horizontalLine.lineWidth = insideLineWidth;
            verticalLine.lineWidth  = insideLineWidth;
        }
        
        [[UIColor blackColor] setStroke];
        
        [horizontalLine stroke];
        [verticalLine stroke];
    }
    
    // 创建黑点
    if (CHECKER_BOARD_SIZE_N14 == _board_size) {
        int dotRadiusList[5] = { 3, 3, 4, 3, 3 };
        int dotLocationList[5][2] = { {3, 3}, {3, 11}, {7, 7}, {11, 3}, {11, 11} };
        for (int i = 0; i < 5; i++) {
            CGFloat dotRadius = dotRadiusList[i];
            CGFloat centerX = _margin + dotLocationList[i][0] * _interval;
            CGFloat centerY = _margin + dotLocationList[i][1] * _interval;
            CGRect rect = CGRectMake(centerX - dotRadius, centerY - dotRadius, dotRadius * 2, dotRadius * 2);
            UIBezierPath *dot = [UIBezierPath bezierPathWithOvalInRect:rect];
            [[UIColor blackColor] setFill];
            [dot fill];
        }
    } else if (CHECKER_BOARD_SIZE_N12 == _board_size) {
        int dotRadiusList[5] = { 3, 3, 4, 3, 3 };
        int dotLocationList[5][2] = { {3, 3}, {3, 9}, {6, 6}, {9, 3}, {9, 9} };
        for (int i = 0; i < 5; i++) {
            CGFloat dotRadius = dotRadiusList[i];
            CGFloat centerX = _margin + dotLocationList[i][0] * _interval;
            CGFloat centerY = _margin + dotLocationList[i][1] * _interval;
            CGRect rect = CGRectMake(centerX - dotRadius, centerY - dotRadius, dotRadius * 2, dotRadius * 2);
            UIBezierPath *dot = [UIBezierPath bezierPathWithOvalInRect:rect];
            [[UIColor blackColor] setFill];
            [dot fill];
        }
    } else if (CHECKER_BOARD_SIZE_N10 == _board_size) {
        int dotRadiusList[1] = { 4 };
        int dotLocationList[1][2] = { {5, 5} };
        for (int i = 0; i < 1; i++) {
            CGFloat dotRadius = dotRadiusList[i];
            CGFloat centerX = _margin + dotLocationList[i][0] * _interval;
            CGFloat centerY = _margin + dotLocationList[i][1] * _interval;
            CGRect rect = CGRectMake(centerX - dotRadius, centerY - dotRadius, dotRadius * 2, dotRadius * 2);
            UIBezierPath *dot = [UIBezierPath bezierPathWithOvalInRect:rect];
            [[UIColor blackColor] setFill];
            [dot fill];
        }
    } else if (CHECKER_BOARD_SIZE_N08 == _board_size) {
        int dotRadiusList[1] = { 4 };
        int dotLocationList[1][2] = { {4, 4} };
        for (int i = 0; i < 1; i++) {
            CGFloat dotRadius = dotRadiusList[i];
            CGFloat centerX = _margin + dotLocationList[i][0] * _interval;
            CGFloat centerY = _margin + dotLocationList[i][1] * _interval;
            CGRect rect = CGRectMake(centerX - dotRadius, centerY - dotRadius, dotRadius * 2, dotRadius * 2);
            UIBezierPath *dot = [UIBezierPath bezierPathWithOvalInRect:rect];
            [[UIColor blackColor] setFill];
            [dot fill];
        }
    }
}


@end

