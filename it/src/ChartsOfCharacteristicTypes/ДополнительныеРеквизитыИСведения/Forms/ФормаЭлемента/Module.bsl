////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// Обработчик подсистемы запрета редактирования реквизитов объектов.
	//ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма); 		//Комиссаров: 05/08/2013
	
	ЕдинственноеЧислоПредмета  = СтрПолучитьСтроку(Объект.СклоненияПредмета, 1);
	МножественноеЧислоПредмета = СтрПолучитьСтроку(Объект.СклоненияПредмета, 2);
	
	РедактированиеСоставаНаборовРазрешено =
		Параметры.РедактированиеСоставаНаборовРазрешено
		И ПравоДоступа("Редактирование", Объект.Ссылка.Метаданные());
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Элементы.ЭтоДополнительноеСведениеРеквизит.Доступность = Ложь;
		
	ИначеЕсли Параметры.ЭтоДополнительноеСведение <> Неопределено Тогда
		Элементы.ЭтоДополнительноеСведениеРеквизит.Доступность = Ложь;
		Объект.ЭтоДополнительноеСведение = Параметры.ЭтоДополнительноеСведение;
	КонецЕсли;
	
	ЭтоДополнительноеСведениеРеквизит = ?(Объект.ЭтоДополнительноеСведение, 1, 0);
	
	ОбновитьСоставЭлементовФормы();
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ДополнительныеРеквизиты.Ссылка КАК Набор,
		|	ДополнительныеРеквизиты.Ссылка.Наименование
		|ИЗ
		|	Справочник.НаборыДополнительныхРеквизитовИСведений.ДополнительныеРеквизиты КАК ДополнительныеРеквизиты
		|ГДЕ
		|	ДополнительныеРеквизиты.Свойство = &Свойство
		|	И НЕ ДополнительныеРеквизиты.Ссылка.ЭтоГруппа
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ДополнительныеСведения.Ссылка,
		|	ДополнительныеСведения.Ссылка.Наименование
		|ИЗ
		|	Справочник.НаборыДополнительныхРеквизитовИСведений.ДополнительныеСведения КАК ДополнительныеСведения
		|ГДЕ
		|	ДополнительныеСведения.Свойство = &Свойство
		|	И НЕ ДополнительныеСведения.Ссылка.ЭтоГруппа");
		
		Запрос.УстановитьПараметр("Свойство", Объект.Ссылка);
		
		НачатьТранзакцию();
		Попытка
			Выборка = Запрос.Выполнить().Выбрать();
			Пока Выборка.Следующий() Цикл
				СписокНаборов.Добавить(Выборка.Набор, Выборка.Наименование);
			КонецЦикла;
			
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ВызватьИсключение;
		КонецПопытки;
	Иначе
		Если Параметры.ЭтоДополнительноеСведение <> Неопределено Тогда
			
		КонецЕсли;
		
	КонецЕсли;
	
	ОбновитьНадписьОНаборах();
	
	Если Объект.МногострочноеПолеВвода > 0 Тогда
		МногострочноеПолеВвода = Истина;
		МногострочноеПолеВводаЧисло = Объект.МногострочноеПолеВвода;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	ИмяФормыРазблокированиеРеквизитов =
		"ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения.Форма.РазблокированиеРеквизитов";
	
	ИмяФормыРедактированиеСоставаНаборов =
		"Справочник.НаборыДополнительныхРеквизитовИСведений.Форма.РедактированиеСоставаНаборов";
	
	Если ВРег(ИсточникВыбора.ИмяФормы) = ВРег(ИмяФормыРазблокированиеРеквизитов) Тогда
		
		//ЗапретРедактированияРеквизитовОбъектовКлиент.УстановитьДоступностьЭлементовФормы(  		//Комиссаров: 05/08/2013
		//	ЭтаФорма, ВыбранноеЗначение);
		
	ИначеЕсли ВРег(ИсточникВыбора.ИмяФормы) = ВРег(ИмяФормыРедактированиеСоставаНаборов) Тогда
		
		Если НЕ РедактированиеСоставаНаборовРазрешено Тогда
			Возврат;
		КонецЕсли;
		
		СписокНаборов = ВыбранноеЗначение;
		Модифицированность = Истина;
		
		ОбновитьНадписьОНаборах();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ)
	
	// Проверка есть ли свойство с тем же наименованием.
	Если НаименованиеУжеИспользуется(Объект.Наименование, Объект.Ссылка) Тогда
		
		ТекстВопроса = НСтр("ru = 'С указанным наименованием уже был введен ранее доп.реквизит/сведение.
		                          |Продолжить запись?'");
		Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
		Если Ответ = КодВозвратаДиалога.Отмена Тогда
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если УправлениеСвойствамиСлужебный.ТипЗначенияСодержитЗначенияСвойств(Объект.ТипЗначения) Тогда
		ТекущийОбъект.СклоненияПредмета = ЕдинственноеЧислоПредмета + Символы.ПС + МножественноеЧислоПредмета;
	Иначе
		ТекущийОбъект.СклоненияПредмета = "";
	КонецЕсли;
	
	Если Объект.ЭтоДополнительноеСведение
	 ИЛИ НЕ (    Объект.ТипЗначения.СодержитТип(Тип("Число" ))
	         ИЛИ Объект.ТипЗначения.СодержитТип(Тип("Дата"  ))
	         ИЛИ Объект.ТипЗначения.СодержитТип(Тип("Булево")) )Тогда
		
		ТекущийОбъект.ФорматСвойства = "";
	КонецЕсли;
	
	ТекущийОбъект.МногострочноеПолеВвода = 0;
	
	Если НЕ Объект.ЭтоДополнительноеСведение
	   И Объект.ТипЗначения.Типы().Количество() = 1
	   И Объект.ТипЗначения.СодержитТип(Тип("Строка")) Тогда
		
		Если МногострочноеПолеВвода Тогда
			ТекущийОбъект.МногострочноеПолеВвода = МногострочноеПолеВводаЧисло;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект)
	
	Если НЕ РедактированиеСоставаНаборовРазрешено Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ДополнительныеРеквизиты.Ссылка КАК Набор,
	|	ЛОЖЬ КАК ВходитВНабор,
	|	ЛОЖЬ КАК ДополнительноеСведение
	|ИЗ
	|	Справочник.НаборыДополнительныхРеквизитовИСведений.ДополнительныеРеквизиты КАК ДополнительныеРеквизиты
	|ГДЕ
	|	(НЕ ДополнительныеРеквизиты.Ссылка В (&ВключенВНаборы)
	|			ИЛИ &ЭтоДополнительноеСведение)
	|	И НЕ ДополнительныеРеквизиты.Ссылка.ЭтоГруппа
	|	И ДополнительныеРеквизиты.Свойство = &Свойство
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ДополнительныеСведения.Ссылка,
	|	ЛОЖЬ,
	|	ИСТИНА
	|ИЗ
	|	Справочник.НаборыДополнительныхРеквизитовИСведений.ДополнительныеСведения КАК ДополнительныеСведения
	|ГДЕ
	|	(НЕ ДополнительныеСведения.Ссылка В (&ВключенВНаборы)
	|			ИЛИ НЕ &ЭтоДополнительноеСведение)
	|	И НЕ ДополнительныеСведения.Ссылка.ЭтоГруппа
	|	И ДополнительныеСведения.Свойство = &Свойство
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	НаборыДополнительныхРеквизитовИСведений.Ссылка,
	|	ИСТИНА,
	|	&ЭтоДополнительноеСведение
	|ИЗ
	|	Справочник.НаборыДополнительныхРеквизитовИСведений КАК НаборыДополнительныхРеквизитовИСведений
	|ГДЕ
	|	НаборыДополнительныхРеквизитовИСведений.Ссылка В(&ВключенВНаборы)
	|	И НЕ НаборыДополнительныхРеквизитовИСведений.ДополнительныеРеквизиты.Ссылка В
	|				(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|					ДополнительныеРеквизиты.Ссылка КАК Набор
	|				ИЗ
	|					Справочник.НаборыДополнительныхРеквизитовИСведений.ДополнительныеРеквизиты КАК ДополнительныеРеквизиты
	|				ГДЕ
	|					ДополнительныеРеквизиты.Ссылка В (&ВключенВНаборы)
	|					И НЕ ДополнительныеРеквизиты.Ссылка.ЭтоГруппа
	|					И ДополнительныеРеквизиты.Свойство = &Свойство
	|					И НЕ &ЭтоДополнительноеСведение
	|		
	|				ОБЪЕДИНИТЬ ВСЕ
	|		
	|				ВЫБРАТЬ РАЗЛИЧНЫЕ
	|					ДополнительныеСведения.Ссылка КАК Набор
	|				ИЗ
	|					Справочник.НаборыДополнительныхРеквизитовИСведений.ДополнительныеСведения КАК ДополнительныеСведения
	|				ГДЕ
	|					ДополнительныеСведения.Ссылка В (&ВключенВНаборы)
	|					И НЕ ДополнительныеСведения.Ссылка.ЭтоГруппа
	|					И ДополнительныеСведения.Свойство = &Свойство
	|					И &ЭтоДополнительноеСведение)");
	
	Запрос.Параметры.Вставить("Свойство",                  ТекущийОбъект.Ссылка);
	Запрос.Параметры.Вставить("ЭтоДополнительноеСведение", ТекущийОбъект.ЭтоДополнительноеСведение);
	Запрос.Параметры.Вставить("ВключенВНаборы",            СписокНаборов);
	
	НачатьТранзакцию();
	Попытка
		РезультатЗапроса = Запрос.Выполнить();
		Выборка = РезультатЗапроса.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			НаборСвойств = Выборка.Набор.ПолучитьОбъект();
			ЗаблокироватьДанныеДляРедактирования(Выборка.Набор);
			
			Если Выборка.ВходитВНабор Тогда
				
				Если Выборка.ДополнительноеСведение Тогда
					
					НаборСвойств.ДополнительныеСведения.Добавить().Свойство = ТекущийОбъект.Ссылка;
				Иначе
					НаборСвойств.ДополнительныеРеквизиты.Добавить().Свойство = ТекущийОбъект.Ссылка;
				КонецЕсли;
			Иначе
				Если Выборка.ДополнительноеСведение Тогда
					
					НаборСвойств.ДополнительныеСведения.Удалить(
						НаборСвойств.ДополнительныеСведения.Найти(ТекущийОбъект.Ссылка, "Свойство"));
				Иначе
					НаборСвойств.ДополнительныеРеквизиты.Удалить(
						НаборСвойств.ДополнительныеРеквизиты.Найти(ТекущийОбъект.Ссылка, "Свойство"));
				КонецЕсли;
			КонецЕсли;
			
			НаборСвойств.Записать();
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// Обработчик подсистемы запрета редактирования реквизитов объектов.
	//ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма); 		//Комиссаров: 05/08/2013
	
	Заголовок = ПолучитьЗаголовок(Объект.Ссылка, Объект.ЭтоДополнительноеСведение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	СтруктураОповещения = Новый Структура;
	СтруктураОповещения.Вставить("Свойство", Объект.Ссылка);
	СтруктураОповещения.Вставить("ЭтоДополнительноеСведение", Объект.ЭтоДополнительноеСведение);
	СтруктураОповещения.Вставить("Комментарий",               Объект.Комментарий);
	
	Оповестить("Запись_ДополнительныеРеквизитыИСведения", СтруктураОповещения, Объект.Ссылка);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ЭтоДополнительноеСведениеРеквизитПриИзменении(Элемент)
	
	Объект.ЭтоДополнительноеСведение = ЭтоДополнительноеСведениеРеквизит;
	
	ОбновитьСоставЭлементовФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ТипЗначенияПриИзменении(Элемент)
	
	Если Объект.ТипЗначения.СодержитТип(Тип("СправочникСсылка.ЗначенияСвойствОбъектовИерархия"))
	   И Объект.ТипЗначения.СодержитТип(Тип("СправочникСсылка.ЗначенияСвойствОбъектов")) Тогда
		
		Предупреждение(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Недопустимо одновременно использовать типы значения
			           |""%1"" и
			           |""%2"".
			           |
			           |Второй тип удален.'"),
			Строка(Тип("СправочникСсылка.ЗначенияСвойствОбъектов")),
			Строка(Тип("СправочникСсылка.ЗначенияСвойствОбъектовИерархия")) ));
		
		// Удаление второго типа.
		Объект.ТипЗначения = Новый ОписаниеТипов(
			Объект.ТипЗначения,
			,
			"СправочникСсылка.ЗначенияСвойствОбъектовИерархия");
	КонецЕсли;
	
	ОбновитьСоставЭлементовФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура МногострочноеПолеВводаЧислоПриИзменении(Элемент)
	
	МногострочноеПолеВвода = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОбщегоНазначенияКлиент.ОткрытьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования,
		Объект.Комментарий,
		Модифицированность);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура РедактироватьСписокНаборов(Команда)
	
	ОткрытьСписокНаборов();
	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьФорматЗначения(Команда)
	
	Конструктор = Новый КонструкторФорматнойСтроки(Объект.ФорматСвойства);
	
	Конструктор.ДоступныеТипы = Объект.ТипЗначения;
	
	Если Конструктор.ОткрытьМодально() Тогда
		Объект.ФорматСвойства = Конструктор.Текст;
		УстановитьЗаголовокКнопкиФормата(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	//ЗаблокированныеРеквизиты = ЗапретРедактированияРеквизитовОбъектовКлиент.РеквизитыКромеНевидимых(ЭтаФорма); 		//Комиссаров: 05/08/2013
	//
	//Если ЗаблокированныеРеквизиты.Количество() > 0 Тогда
	//	
	//	ПараметрыФормы = Новый Структура;
	//	ПараметрыФормы.Вставить("Ссылка", Объект.Ссылка);
	//	ПараметрыФормы.Вставить("ЭтоДополнительныйРеквизит", ЭтоДополнительноеСведениеРеквизит = 0);
	//	
	//	ОткрытьФорму(
	//		"ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения.Форма.РазблокированиеРеквизитов",
	//		ПараметрыФормы,
	//		ЭтаФорма);
	//Иначе
	//	ЗапретРедактированияРеквизитовОбъектовКлиент.ПредупреждениеВсеВидимыеРеквизитыРазблокированы();
	//КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ОбновитьСоставЭлементовФормы()
	
	Заголовок = ПолучитьЗаголовок(Объект.Ссылка, Объект.ЭтоДополнительноеСведение);
	
	Если НЕ Объект.ТипЗначения.СодержитТип(Тип("Число"))
	   И НЕ Объект.ТипЗначения.СодержитТип(Тип("Дата"))
	   И НЕ Объект.ТипЗначения.СодержитТип(Тип("Булево")) Тогда
		
		Объект.ФорматСвойства = "";
	КонецЕсли;
	
	УстановитьЗаголовокКнопкиФормата(ЭтаФорма);
	
	Если УправлениеСвойствамиСлужебный.ТипЗначенияСодержитЗначенияСвойств(Объект.ТипЗначения) Тогда
		Элементы.ГруппаСклонения.Видимость = Истина;
	Иначе
		Элементы.ГруппаСклонения.Видимость = Ложь;
	КонецЕсли;
	
	Если Объект.ЭтоДополнительноеСведение
	 ИЛИ НЕ (    Объект.ТипЗначения.СодержитТип(Тип("Число" ))
	         ИЛИ Объект.ТипЗначения.СодержитТип(Тип("Дата"  ))
	         ИЛИ Объект.ТипЗначения.СодержитТип(Тип("Булево")) )Тогда
		
		Элементы.РедактироватьФорматЗначения.Видимость = Ложь;
	Иначе
		Элементы.РедактироватьФорматЗначения.Видимость = Истина;
	КонецЕсли;
	
	Если НЕ Объект.ЭтоДополнительноеСведение
	   И Объект.ТипЗначения.Типы().Количество() = 1
	   И Объект.ТипЗначения.СодержитТип(Тип("Строка")) Тогда
		
		Элементы.ГруппаМногострочность.Видимость = Истина;
	Иначе
		Элементы.ГруппаМногострочность.Видимость = Ложь;
	КонецЕсли;
	
	Если Объект.ЭтоДополнительноеСведение Тогда
		Объект.ЗаполнятьОбязательно = Ложь;
		Элементы.ЗаполнятьОбязательно.Видимость = Ложь;
	Иначе
		Элементы.ЗаполнятьОбязательно.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьНадписьОНаборах()
	
	Количество = СписокНаборов.Количество();
	Если Количество = 0 Тогда
		ИнформационнаяНадпись = НСтр("ru = 'Не входит ни в один набор'");
		
	ИначеЕсли Количество = 1 Тогда
		ИнформационнаяНадпись = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Входит в набор: %1'"),
			СписокНаборов[0].Представление);
	Иначе
		СтрокаНаборы = СокрЛП(ЧислоПрописью(Количество, "НД=Ложь", "набор,набора,наборов,м,,,,,0"));
		Пока Истина Цикл
			Позиция = Найти(СтрокаНаборы, " ");
			Если Позиция = 0 Тогда
				Прервать;
			КонецЕсли;
			СтрокаНаборы =СокрЛП(Сред(СтрокаНаборы, Позиция + 1));
		КонецЦикла;
		
		ИнформационнаяНадпись = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Входит в %1 %2'"),
			Количество,
			СтрокаНаборы);
	КонецЕсли;
	
	Элементы.РедактироватьСписокНаборов.Заголовок = ИнформационнаяНадпись;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция НаименованиеУжеИспользуется(Знач Наименование, Знач Ссылка)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	1
	|ИЗ
	|	ПланВидовХарактеристик.ДополнительныеРеквизитыИСведения КАК ДополнительныеРеквизитыИСведения
	|ГДЕ
	|	ДополнительныеРеквизитыИСведения.Наименование = &Наименование
	|	И ДополнительныеРеквизитыИСведения.Ссылка <> &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка",       Ссылка);
	Запрос.УстановитьПараметр("Наименование", Наименование);
	
	НачатьТранзакцию();
	Попытка
		Результат = НЕ Запрос.Выполнить().Пустой();
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьЗаголовок(Знач Ссылка, Знач ЭтоДополнительноеСведение)
	
	Если ЗначениеЗаполнено(Ссылка) Тогда
		Заголовок = Строка(Ссылка);
		Если ЭтоДополнительноеСведение Тогда
			Заголовок = Заголовок + " " + НСтр("ru = '(Дополнительное сведение)'");
		Иначе
			Заголовок = Заголовок + " " + НСтр("ru = '(Дополнительный реквизит)'");
		КонецЕсли;
	Иначе
		Если ЭтоДополнительноеСведение Тогда
			Заголовок = НСтр("ru = 'Дополнительное сведение (создание)'");
		Иначе
			Заголовок = НСтр("ru = 'Дополнительный реквизит (создание)'");
		КонецЕсли;
	КонецЕсли;
	
	Возврат Заголовок;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьЗаголовокКнопкиФормата(Форма)
	
	Если ПустаяСтрока(Форма.Объект.ФорматСвойства) Тогда
		ТекстЗаголовка = НСтр("ru = 'Формат по умолчанию'");
	Иначе
		ТекстЗаголовка = НСтр("ru = 'Формат установлен'");
	КонецЕсли;
	
	Форма.Элементы.РедактироватьФорматЗначения.Заголовок = ТекстЗаголовка;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСписокНаборов()
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВыбранныеНаборы",           СписокНаборов);
	ПараметрыФормы.Вставить("ЭтоДополнительноеСведение", Объект.ЭтоДополнительноеСведение);
	
	ПараметрыФормы.Вставить(
		"РедактированиеСоставаНаборовРазрешено", РедактированиеСоставаНаборовРазрешено);
	
	ОткрытьФорму(
		"Справочник.НаборыДополнительныхРеквизитовИСведений.Форма.РедактированиеСоставаНаборов",
		ПараметрыФормы,
		ЭтаФорма);
	
КонецПроцедуры
