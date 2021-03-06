
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервере
Процедура ЗадатьПараметрыДляКомплектующихВСоставе()
	
	Стр_Отб = Новый Структура;
	Стр_Отб.Вставить("ВидДвижения", Перечисления.ВидДвиженияНакопления.Расход);
	ТЗ_Расхода = ОС_ПринадлежащиеЛицензии.Выгрузить(Стр_Отб);
	
	Стр_Отб = Новый Структура;
	Стр_Отб.Вставить("ВидДвижения", Перечисления.ВидДвиженияНакопления.Приход);
	ТЗ_Прихода = ОС_ПринадлежащиеЛицензии.Выгрузить(Стр_Отб);
	
	ПараметрыГраницы = Новый Массив(2);
	//Если ЭтоНовый Тогда
	//	ПараметрыГраницы[0] = ТекущаяДата();
	//Иначе
		ПараметрыГраницы[0] = Объект.Дата;
	//КонецЕсли; 
	ПараметрыГраницы[1] = ВидГраницы.Включая;
	МоментАнализа = Новый(Тип("Граница"),ПараметрыГраницы);
	
	ОС_НеИмеющиеЛицензию.Параметры.УстановитьЗначениеПараметра("МоментАнализа", МоментАнализа);
	ОС_НеИмеющиеЛицензию.Параметры.УстановитьЗначениеПараметра("Организация", Объект.Организация);
	ОС_НеИмеющиеЛицензию.Параметры.УстановитьЗначениеПараметра("СписокОСУбранныхИзРаспределения", ТЗ_Расхода.ВыгрузитьКолонку("ОС"));
	ОС_НеИмеющиеЛицензию.Параметры.УстановитьЗначениеПараметра("СписокОСДобавленныхВРаспределение", ТЗ_Прихода.ВыгрузитьКолонку("ОС"));
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьТЗ_ОСПринадлежащихЛицензии()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	РаспределениеЛицензийОсновныеСредства.ОсновноеСредство КАК ОС,
	               |	РаспределениеЛицензийОсновныеСредства.ВидДвижения
	               |ИЗ
	               |	Документ.РаспределениеЛицензий.ОсновныеСредства КАК РаспределениеЛицензийОсновныеСредства
	               |ГДЕ
	               |	РаспределениеЛицензийОсновныеСредства.Ссылка = &Ссылка
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	ЛицензииПринадлежащиеОСОстатки.ИдентификаторКомпьютера,
	               |	""""
	               |ИЗ
	               |	РегистрНакопления.РазмещениеЛицензий.Остатки(&МоментАнализа, Лицензия = &Лицензия) КАК ЛицензииПринадлежащиеОСОстатки";
	
	Запрос.УстановитьПараметр("МоментАнализа", Объект.Дата);
	Запрос.УстановитьПараметр("Лицензия", Объект.Лицензия);
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	
	ОС_ПринадлежащиеЛицензии.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ УПРАВЛЕНИЯ ТАБЛИЧНЫМ ПОЛЕМ КОМПЛЕКТУЮЩИЕ

&НаСервере
Процедура ДобавитьОСНаСервере(ОС)
	
	Стр_Отб= Новый Структура;
	Стр_Отб.Вставить("ОС", ОС);
	
	Масс_ТЗ = ОС_ПринадлежащиеЛицензии.НайтиСтроки(Стр_Отб);
	
	Если Масс_ТЗ.Количество() > 0 Тогда
		Масс_ТЗ[0].ВидДвижения 	= Перечисления.ВидДвиженияНакопления.ПустаяСсылка();
	Иначе
		Стр_ТЗ = ОС_ПринадлежащиеЛицензии.Добавить();
		Стр_ТЗ.ОС 			= ОС;
		Стр_ТЗ.ВидДвижения 	= Перечисления.ВидДвиженияНакопления.Приход;
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьОС(Команда)
	
	Если Этаформа.Элементы.ОС_НеИмеющиеЛицензию.ТекущиеДанные <> Неопределено Тогда
		ДобавитьОСНаСервере(Этаформа.Элементы.ОС_НеИмеющиеЛицензию.ТекущиеДанные.ОсновноеСредство);
		ЗадатьПараметрыДляКомплектующихВСоставе();
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура УбратьОСНаСервере(ОС)
	
	Стр_Отб= Новый Структура;
	Стр_Отб.Вставить("ОС", ОС);
	
	Масс_ТЗ = ОС_ПринадлежащиеЛицензии.НайтиСтроки(Стр_Отб);
	
	НМ_ = Масс_ТЗ.Количество();
	Пока НМ_ <> 0 Цикл
		ОС_ПринадлежащиеЛицензии.Удалить(Масс_ТЗ[НМ_-1]);
		НМ_ = НМ_ - 1;
	КонецЦикла; 
	
КонецПроцедуры

&НаКлиенте
Процедура УбратьОС(Команда)
	
	Если Этаформа.Элементы.ОС_ПринадлежащиеЛицензии.ТекущиеДанные <> Неопределено Тогда
		УбратьОСНаСервере(Этаформа.Элементы.ОС_ПринадлежащиеЛицензии.ТекущиеДанные.ОС);
		ЗадатьПараметрыДляКомплектующихВСоставе();
	КонецЕсли; 
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ЗадатьПараметрыДляКомплектующихВСоставе();
	ПолучитьТЗ_ОСПринадлежащихЛицензии();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Объект.Ссылка = Документы.РаспределениеЛицензий.ПустаяСсылка() Тогда
		ЭтоНовый = Истина;
		Объект.Дата = ТекущаяДата();
	Иначе
		ЭтоНовый = Ложь;
	КонецЕсли; 
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ 

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ЗадатьПараметрыДляКомплектующихВСоставе();
КонецПроцедуры

&НаКлиенте
Процедура ЛицензияПриИзменении(Элемент)
	ПолучитьТЗ_ОСПринадлежащихЛицензии();
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Стр_Отб = Новый Структура;
	Стр_Отб.Вставить("ВидДвижения", Перечисления.ВидДвиженияНакопления.Расход);
	ТЗ_Расхода = ОС_ПринадлежащиеЛицензии.Выгрузить(Стр_Отб);
	
	Стр_Отб = Новый Структура;
	Стр_Отб.Вставить("ВидДвижения", Перечисления.ВидДвиженияНакопления.Приход);
	ТЗ_Прихода = ОС_ПринадлежащиеЛицензии.Выгрузить(Стр_Отб);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	//ПередЗаписьюНаСервере();
	Объект.ОсновныеСредства.Очистить();
	Для каждого Стр_ОС_Приндлеж Из ОС_ПринадлежащиеЛицензии Цикл
		Если ЗначениеЗаполнено(Стр_ОС_Приндлеж.ВидДвижения) Тогда
			Стр_ОС = Объект.ОсновныеСредства.Добавить();
			Стр_ОС.ВидДвижения = Стр_ОС_Приндлеж.ВидДвижения; 
			Стр_ОС.ОсновноеСредство = Стр_ОС_Приндлеж.ОС; 
		КонецЕсли; 
	КонецЦикла; 
КонецПроцедуры
