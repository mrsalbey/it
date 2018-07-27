////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.РежимВыбора Тогда
		РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	КонецЕсли;
	
	Если Параметры.Свойство("Заголовок") Тогда
		АвтоЗаголовок = Ложь;
		Заголовок = Параметры.Заголовок;
	КонецЕсли;
	Если Параметры.Свойство("Отображение") Тогда
		Элементы.Список.Отображение = ОтображениеТаблицы[Параметры.Отображение];
	КонецЕсли;
	
	СписокВыбора = Элементы.ПубликацияОтбор.СписокВыбора;
	СписокВыбора.Добавить(Неопределено, " "); // НСтр("ru = 'Все'")
	
	ВидИспользуется = Перечисления.ВариантыПубликацииДополнительныхОтчетовИОбработок.Используется;
	ВидОтключена = Перечисления.ВариантыПубликацииДополнительныхОтчетовИОбработок.Отключена;
	ВидРежимОтладки = Перечисления.ВариантыПубликацииДополнительныхОтчетовИОбработок.РежимОтладки;
	
	ДоступныеВидыПубликации = ДополнительныеОтчетыИОбработкиПовтИсп.ДоступныеВидыПубликации();
	
	ВсеПубликацииКромеНеиспользующихся = Новый Массив;
	ВсеПубликацииКромеНеиспользующихся.Добавить(ВидИспользуется);
	Если ДоступныеВидыПубликации.Найти(ВидРежимОтладки) <> Неопределено Тогда
		ВсеПубликацииКромеНеиспользующихся.Добавить(ВидРежимОтладки);
	КонецЕсли;
	
	Если ВсеПубликацииКромеНеиспользующихся.Количество() > 1 Тогда
		
		ПредставлениеМассива = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1 или %2'"),
			Строка(ВсеПубликацииКромеНеиспользующихся[0]),
			Строка(ВсеПубликацииКромеНеиспользующихся[1]));
		
		СписокВыбора.Добавить(1, ПредставлениеМассива);
		
	КонецЕсли;
	
	Для Каждого ЗначениеПеречисления Из Перечисления.ВариантыПубликацииДополнительныхОтчетовИОбработок Цикл
		Если ДоступныеВидыПубликации.Найти(ЗначениеПеречисления) <> Неопределено Тогда
			СписокВыбора.Добавить(ЗначениеПеречисления, Строка(ЗначениеПеречисления));
		КонецЕсли;
	КонецЦикла;
	
	СписокВыбора = Элементы.ВидОтбор.СписокВыбора;
	СписокВыбора.Добавить(Неопределено, " "); //НСтр("ru = 'Все отчеты и обработки'")
	СписокВыбора.Добавить(1, НСтр("ru = 'Только отчеты'"));
	СписокВыбора.Добавить(2, НСтр("ru = 'Только обработки'"));
	Для Каждого ЗначениеПеречисления Из Перечисления.ВидыДополнительныхОтчетовИОбработок Цикл
		СписокВыбора.Добавить(ЗначениеПеречисления, Строка(ЗначениеПеречисления));
	КонецЦикла;
	
	ВидыДопОтчетов = Новый Массив;
	ВидыДопОтчетов.Добавить(Перечисления.ВидыДополнительныхОтчетовИОбработок.ДополнительныйОтчет);
	ВидыДопОтчетов.Добавить(Перечисления.ВидыДополнительныхОтчетовИОбработок.Отчет);
	
	Список.Параметры.УстановитьЗначениеПараметра("ПубликацияОтбор", ПубликацияОтбор);
	Список.Параметры.УстановитьЗначениеПараметра("ВидОтбор",        ВидОтбор);
	Список.Параметры.УстановитьЗначениеПараметра("ВидыДопОтчетов",  ВидыДопОтчетов);
	Список.Параметры.УстановитьЗначениеПараметра("ВсеПубликацииКромеНеиспользующихся", ВсеПубликацииКромеНеиспользующихся);
	
	Элементы.КнопкиДобавления.Видимость = ДополнительныеОтчетыИОбработки.ПравоДобавления();
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	ПубликацияОтбор = Настройки.Получить("ПубликацияОтбор");
	ВидОтбор        = Настройки.Получить("ВидОтбор");
	Список.Параметры.УстановитьЗначениеПараметра("ПубликацияОтбор", ПубликацияОтбор);
	Список.Параметры.УстановитьЗначениеПараметра("ВидОтбор",        ВидОтбор);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ПубликацияОтборПриИзменении(Элемент)
	ЗначениеПараметраКД = Список.Параметры.Элементы.Найти("ПубликацияОтбор");
	Если ЗначениеПараметраКД.Значение <> ПубликацияОтбор Тогда
		ЗначениеПараметраКД.Значение = ПубликацияОтбор;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВидОтборПриИзменении(Элемент)
	ЗначениеПараметраКД = Список.Параметры.Элементы.Найти("ВидОтбор");
	Если ЗначениеПараметраКД.Значение <> ВидОтбор Тогда
		ЗначениеПараметраКД.Значение = ВидОтбор;
	КонецЕсли;
КонецПроцедуры

