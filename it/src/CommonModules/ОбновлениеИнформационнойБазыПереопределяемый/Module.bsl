////////////////////////////////////////////////////////////////////////////////
// Подсистема "Обновление версии ИБ"
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Возвращает список процедур-обработчиков обновления ИБ для всех поддерживаемых версий ИБ.
//
// Пример добавления процедуры-обработчика в список:
//    Обработчик = Обработчики.Добавить();
//    Обработчик.Версия = "1.1.0.0";
//    Обработчик.Процедура = "ОбновлениеИБ.ПерейтиНаВерсию_1_1_0_0";
//
// Вызывается перед началом обновления данных ИБ.
//
Функция ОбработчикиОбновления() Экспорт
	
	Обработчики = ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления();
	
	// Подключаются процедуры-обработчики обновления конфигурации
	
	// _Демо начало примера
	//
	// См. процедуру ПриДобавленииПодсистем(МодулиПодсистем) в модуле
	// ПодсистемыКонфигурацииПереопределяемый
	// и
	// процедуру ПриДобавленииОбработчиковОбновления(Обработчики) в модуле
	// _ДемоОбновлениеИнформационнойБазыБСП
	//
	// _Демо конец примера
	
	Возврат Обработчики;
	
КонецФункции

// Вызывается перед обработчиками обновления данных ИБ.
//
Процедура ПередОбновлениемИнформационнойБазы() Экспорт
	
	
	
КонецПроцедуры

// Вызывается после завершении обновления данных ИБ.
// 
// Параметры:
//   ПредыдущаяВерсияИБ     - Строка - версия ИБ до обновления. "0.0.0.0" для "пустой" ИБ.
//   ТекущаяВерсияИБ        - Строка - версия ИБ после обновления.
//   ВыполненныеОбработчики - ДеревоЗначений - список выполненных процедур-обработчиков
//                                             обновления, сгруппированных по номеру версии.
//  Итерирование по выполненным обработчикам:
//		Для Каждого Версия Из ВыполненныеОбработчики.Строки Цикл
//	
//			Если Версия.Версия = "*" Тогда
//				группа обработчиков, которые выполняются всегда
//			Иначе
//				группа обработчиков, которые выполняются для определенной версии 
//			КонецЕсли;
//	
//			Для Каждого Обработчик Из Версия.Строки Цикл
//				...
//			КонецЦикла;
//	
//		КонецЦикла;
//
//   ВыводитьОписаниеОбновлений - Булево -	если Истина, то выводить форму с описанием 
//											обновлений.
//   МонопольныйРежим           - Булево - признак выполнения обновления в монопольном режиме.
//                                Истина - обновление выполнялось в монопольном режиме.
// 
Процедура ПослеОбновленияИнформационнойБазы(Знач ПредыдущаяВерсияИБ, Знач ТекущаяВерсияИБ,
		Знач ВыполненныеОбработчики, ВыводитьОписаниеОбновлений, МонопольныйРежим) Экспорт
	
	
	
КонецПроцедуры

// Вызывается при подготовке табличного документа с описанием изменений системы.
//
// Параметры:
//   Макет - ТабличныйДокумент - описание обновлений.
//   
// См. также общий макет ОписаниеИзмененийСистемы.
//
Процедура ПриПодготовкеМакетаОписанияОбновлений(Знач Макет) Экспорт
	
	
	
КонецПроцедуры

// Получает список обработчиков обновления ИБ, которые не нужно выполнять.
// Отключать можно только те обработчики, у которых номер версии "*".
//
// Пример добавления отключаемого обработчика в список:
//   НовоеИсключение = ОтключаемыеОбработчики.Добавить();
//   НовоеИсключение.ИдентификаторБиблиотеки = "СтандартныеПодсистемы";
//   НовоеИсключение.Версия = "2.1.2.3";
//   НовоеИсключение.Процедура = "ВариантыОтчетов.Обновить";
//
// Версия - номер версии конфигурации, в которой нужно отключить
//          выполнение обработчика.
//
Процедура ДобавитьОтключаемыеОбработчикиОбновления(ОтключаемыеОбработчики) Экспорт
	
	
КонецПроцедуры
