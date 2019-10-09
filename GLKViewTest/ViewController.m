//
//  ViewController.m
//  LaoChaoBuild
//
//  Created by xiaohua on 2019/8/14.
//  Copyright © 2019 LanChao. All rights reserved.
//

#import "ViewController.h"
#import <GLKit/GLKit.h>
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>


@interface ViewController () <GLKViewDelegate>
{
    EAGLContext * context; //绘制视图内容时使⽤用的OpenGL ES 上下⽂文
    GLKBaseEffect * mEffect; //⼀种简单光照/着⾊系统,⽤于基于着⾊器OpenGL 渲染
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
     整体流程     1.创建ES上下文
     2.创建GLKView并初始化  配置色彩模式及深度模式  开启深度测试
     3.创建顶点数据
     4.创建顶点缓冲区并绑定
     5.将顶点数组copy到顶点缓冲区
     6.获取纹理(图片)   设置读取纹理方式 从左下角开始读
     7.初始化着色器
     8.开始绘画
     */
    
    
    
    //设置基本配置
    [self setUpConig];
    
    //加载顶点数据
    [self uploadVertexArray];
    
    //加载纹理
    [self uploadTexture];
}

//设置配置
-(void)setUpConig{
    //创建ES上下文
    context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    if (context == nil) {
        NSLog(@"failed to create ES context");
        return;
    }
    //    GLKView * view = [[GLKView alloc]initWithFrame:CGRectMake(100, 100, 300, 400)];
    GLKView * view = [[GLKView alloc]initWithFrame:self.view.bounds context:context];
    view.delegate = self;
    [self.view addSubview:view];
    //    view.context = context;
    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    [EAGLContext setCurrentContext:context];
    //开启深度测试 让离得近的物体可以遮挡远的物体
    glEnable(GL_DEPTH_TEST);
    
}

-(void)uploadVertexArray{
    GLfloat vertexData[] = {
        //前三顶点  后2 纹理   2个三角合成的一个矩形
        0.5f,-0.5f,0.0f,    1.0f,0.0f,
        0.5f,0.5f,0.0f,     1.0f,1.0f,
        -0.5f,0.5f,0.0f,    0.0f,1.0f,
        
        0.5f,-0.5f,0.0f,    1.0f,0.0f,
        -0.5f,0.5f,0.0f,    0.0f,1.0f,
        -0.5f,-0.5f,0.0f,   0.0f,0.0f
    };
    //    GLfloat vertexData[] = {
    //        //前三顶点  后2 纹理
    //        1.0f,-1.0f,0.0f,    1.0f,0.0f,
    //        1.0f,1.0f,0.0f,     1.0f,1.0f,
    //        -1.0f,1.0f,0.0f,    0.0f,1.0f,
    //
    //        1.0f,-1.0f,0.0f,    1.0f,0.0f,
    //        -1.0f,1.0f,0.0f,    0.0f,1.0f,
    //        -1.0f,-1.0f,0.0f,   0.0f,0.0f
    //    };
    
    //缓冲区
    GLuint buffer;
    //(1).创建顶点缓冲区标识符
    glGenBuffers(1, &buffer);
    //(2).绑定顶点缓冲区
    glBindBuffer(GL_ARRAY_BUFFER, buffer);
    //(3).将顶点数组的数据copy到顶点缓冲区中
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertexData), vertexData, GL_STATIC_DRAW);
    //交给顶点
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    //读取顶点数据  1类型:顶点  2有几个数据    3数据类型   4点偏移量   5开始位置
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, (GLfloat *)NULL + 0);
    
    //纹理
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    
    //读取纹理数据
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, (GLfloat *)NULL + 3);
    
    
}

-(void)uploadTexture{
    //获取纹理
    NSString * path = [[NSBundle mainBundle] pathForResource:@"185629157" ofType:@"jpg"];
    //读取纹理的方式: 从左下角开始读取
    //    NSDictionary * options = [NSDictionary dictionaryWithObjectsAndKeys:@(1),GLKTextureLoaderOriginBottomLeft, nil];
    NSDictionary * options = @{GLKTextureLoaderOriginBottomLeft:@(YES)};
    GLKTextureInfo * textureInfo = [GLKTextureLoader textureWithContentsOfFile:path options:options error:nil];
    //着色器
    mEffect = [[GLKBaseEffect alloc]init];
    mEffect.texture2d0.enabled = GL_TRUE;
    mEffect.texture2d0.name = textureInfo.name;
    
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    glClearColor(0.8, 0.8, 0.8, 1);
    //清除缓冲区
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    [mEffect prepareToDraw];
    glDrawArrays(GL_TRIANGLES, 0, 6);
}

@end

