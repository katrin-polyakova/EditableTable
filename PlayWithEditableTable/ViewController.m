//
//  ViewController.m
//  PlayWithEditableTable
//
//  Created by Kate Polyakova on 5/9/15.
//  Copyright (c) 2015 Kate Polyakova. All rights reserved.
//

#import "ViewController.h"
#import "NSString+Utils.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *buttonAdd;
@property (weak, nonatomic) IBOutlet UIButton *buttonEdit;

@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) NSArray *emailsEmergency;
@end

@implementation ViewController

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.data = [NSMutableArray array];  // инициализация изменяемого массива, которым заполняется таблица
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Identifier"]; //создание таблицы, состоящей из ячеек

    self.emailsEmergency = @[@" abc@gmail.com", @" qwerty@gmail.com", @" katrin@ukr.net"];
    [self.data addObjectsFromArray:self.emailsEmergency];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count; // вовращает количества строк в таблице
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Identifier" forIndexPath:indexPath]; // создание ячейки таблицы по идентификатору
    cell.textLabel.text = self.data[(NSUInteger) indexPath.row]; // заполнение ячеек в таблице
    if ((NSUInteger)indexPath.row<=self.emailsEmergency.count-1) {
        cell.textLabel.backgroundColor = [UIColor colorWithRed:0 green:0.8f blue:0.5f alpha:1];
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return (NSUInteger)indexPath.row > self.emailsEmergency.count-1; //условие редактирования строк
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
    forRowAtIndexPath:(NSIndexPath *)indexPath {

    if(editingStyle == UITableViewCellEditingStyleDelete){ // ?
        [self.data removeObjectAtIndex: (NSUInteger)indexPath.row]; // удаление нужной строки
        self.buttonEdit.enabled = (self.data.count>0); //кнопка "Edit" доступна, если есть хоть одна строка в таблице
        if (self.data.count == 0) { // если data пуст, то редактирование недоступно
            self.buttonEdit.selected = NO;
            self.tableView.editing = NO;
        }
        [tableView beginUpdates]; // начало updates - система будет ждать updates
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade]; // удаление строки
        [tableView endUpdates]; // конец updates
    }
}

- (IBAction)onAddRowTap: (id) sender {

    NSUInteger currentIndex = self.data.count; // размер массива data
    NSString *str = self.textField.text; // текст из поля ввода
    [self.data addObject:str]; // добавление в изменяемый массив вводимых данных
    self.buttonEdit.enabled = self.data.count>0;
//    [self.tableView reloadData]; - перегрузить все данные

    [self.tableView beginUpdates]; // начало updates - система будет ждать updates
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentIndex inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade]; // добавление в таблицу новых строк
    [self.tableView endUpdates]; // конец updates

    self.textField.text = nil;
    self.buttonAdd.enabled = NO;
}

- (IBAction)onEdit:(id)sender {

    self.buttonEdit.selected = !self.buttonEdit.selected; // нажатие на кнопку "Edit" меняет состояние редактирования
    self.tableView.editing = !self.tableView.editing; // нажатие на кнопку "Edit" меняет состояние редактирования таблицы
//    [self.tableView setEditing:YES];  - то же самое
}


- (IBAction)textChanged:(id)sender {
    self.buttonAdd.enabled = [self.textField.text validateEmail]; //кнопка "+" доступна, если у нас введен email

//    self.buttonAdd.enabled = self.textField.text.length > 0;

//    if (self.textField.text.length > 0) {  - то же самое, что написано выше
//        self.buttonAdd.enabled = YES;
//    }
//    else {
//        self.buttonAdd.enabled = NO;
//    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder]; // ?
    return NO;
}

@end
