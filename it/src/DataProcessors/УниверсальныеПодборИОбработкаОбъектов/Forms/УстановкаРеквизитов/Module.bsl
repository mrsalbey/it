//Признак использования настроек
&НаКлиенте
Перем мИспользоватьНастройки Экспорт;

//Типы объектов, для которых может использоваться обработка.
//По умолчанию для всех.
&НаКлиенте
Перем мТипыОбрабатываемыхОбъектов Экспорт;

&НаКлиенте
Перем мНастройка;

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Выполняет обработку объектов.
//
// Параметры:
//  Объект                 - обрабатываемый объект.
//  ПорядковыйНомерОбъекта - порядковый номер обрабатываемого объекта.
//
&НаСервере
Процедура ОбработатьОбъект(Ссылка, ПорядковыйНомерОбъекта)

	Объект = Ссылка.ПолучитьОбъект();
	Для каждого Реквизит из Реквизиты Цикл
		Если Реквизит.Выбрать Тогда
			Объект[Реквизит.Идентификатор] = Реквизит.Значение;
		КонецЕсли;
	КонецЦикла;
	Объект.Записать();

КонецПроцедуры // ОбработатьОбъект()

// Выполняет обработку объектов.
//
// Параметры:
//  Нет.
//
&НаКлиенте
Функция ВыполнитьОбработку() Экспорт
	
	Индикатор = ПолучитьИндикаторПроцесса(НайденныеОбъекты.Количество());
	Для Индекс = 0 По НайденныеОбъекты.Количество() - 1 Цикл
		ОбработатьИндикатор(Индикатор, Индекс + 1);
		
		Объект = НайденныеОбъекты.Получить(Индекс).Значение;
		ОбработатьОбъект(Объект, Индекс);
	КонецЦикла;
	
	Если Индекс > 0 Тогда
		ОповеститьОбИзменении(Тип(ОбъектПоиска.Тип + "Ссылка." + ОбъектПоиска.Имя));
	КонецЕсли;
	
	Возврат Индекс;
КонецФункции // вВыполнитьОбработку()

// Сохраняет значения реквизитов формы.
//
// Параметры:
//  Нет.
//
&НаКлиенте
Процедура СохранитьНастройку() Экспорт

	Если ПустаяСтрока(ТекущаяНастройкаПредставление) Тогда
		Предупреждение("Задайте имя новой настройки для сохранения или выберите существующую настройку для перезаписи.");
	КонецЕсли;

	НоваяНастройка = Новый Структура;
	НоваяНастройка.Вставить("Обработка", ТекущаяНастройкаПредставление);
	НоваяНастройка.Вставить("Прочее", Новый Структура);
	
	РеквизитыДляСохранения = ПолучитьМассивРеквизитов();
	
	Для каждого РеквизитНастройки из мНастройка Цикл
		Выполнить("НоваяНастройка.Прочее.Вставить(Строка(РеквизитНастройки.Ключ), " + Строка(РеквизитНастройки.Ключ) + ");");
	КонецЦикла;
	
	ДоступныеОбработки = ЭтаФорма.ВладелецФормы.ДоступныеОбработки;
	ТекущаяДоступнаяНастройка = Неопределено;
	Для Каждого ТекущаяДоступнаяНастройка Из ДоступныеОбработки.ПолучитьЭлементы() Цикл
		Если ТекущаяДоступнаяНастройка.ПолучитьИдентификатор() = Родитель Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
    Если ТекущаяНастройка = Неопределено ИЛИ НЕ ТекущаяНастройка.Обработка = ТекущаяНастройкаПредставление Тогда
		Если ТекущаяДоступнаяНастройка <> Неопределено Тогда
			НоваяСтрока = ТекущаяДоступнаяНастройка.ПолучитьЭлементы().Добавить();
			НоваяСтрока.Обработка = ТекущаяНастройкаПредставление;
			НоваяСтрока.Настройка.Добавить(НоваяНастройка);
			
			ЭтаФорма.ВладелецФормы.Элементы.ДоступныеОбработки.Родитель = НоваяСтрока.ПолучитьИдентификатор();
		КонецЕсли;
	КонецЕсли;
	
	Если ТекущаяДоступнаяНастройка <> Неопределено И ТекущаяСтрока > -1 Тогда
		Для Каждого ТекНастройка Из ТекущаяДоступнаяНастройка.ПолучитьЭлементы() Цикл
			Если ТекНастройка.ПолучитьИдентификатор() = ТекущаяСтрока Тогда
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если ТекНастройка.Настройка.Количество() = 0 Тогда
			ТекНастройка.Настройка.Добавить(НоваяНастройка);
		Иначе
			ТекНастройка.Настройка[0].Значение = НоваяНастройка;
		КонецЕсли;
	КонецЕсли;
	
	ТекущаяНастройка = НоваяНастройка;
	ЭтаФорма.Модифицированность = Ложь;
КонецПроцедуры // вСохранитьНастройку()

&НаСервере
Функция ПолучитьМассивРеквизитов()
	МассивРеквизитов = Новый Массив;
	Для Каждого Стр Из Реквизиты Цикл
		Если НЕ Стр.Выбрать Тогда
			Продолжить;
		КонецЕсли;
		
		СтруктураРеквизита = Новый Структура;
		СтруктураРеквизита.Вставить("Выбрать", Стр.Выбрать);
		СтруктураРеквизита.Вставить("Реквизит", Стр.Реквизит);
		СтруктураРеквизита.Вставить("Идентификатор", Стр.Идентификатор);
		СтруктураРеквизита.Вставить("Тип", Стр.Тип);
		СтруктураРеквизита.Вставить("Значение", Стр.Значение);
		
		МассивРеквизитов.Добавить(СтруктураРеквизита);
	КонецЦикла;
	
	Возврат МассивРеквизитов;
КонецФункции

&НаСервере
Процедура ЗагрузитьРеквизитыИзМассива(МассивРеквизитов)
	ТЗ = РеквизитФормыВЗначение("Реквизиты");
	
	Для Каждого Стр Из МассивРеквизитов Цикл
		Если НЕ Стр.Выбрать Тогда
			Продолжить;
		КонецЕсли;
		
		СтруктураПоиска = Новый Структура;
		СтруктураПоиска.Вставить("Реквизит", Стр.Реквизит);
						
		МассивСтрок = ТЗ.НайтиСтроки(СтруктураПоиска);
		Если МассивСтрок.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		ТекСтр = МассивСтрок[0];
		ЗаполнитьЗначенияСвойств(ТекСтр, Стр);
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(ТЗ, "Реквизиты");
КонецПроцедуры

// Восстанавливает сохраненные значения реквизитов формы.
//
// Параметры:
//  Нет.
//
&НаКлиенте
Процедура ЗагрузитьНастройку() Экспорт

	Если Элементы.ТекущаяНастройка.СписокВыбора.Количество() = 0 Тогда
		УстановитьИмяНастройки("Новая настройка");
	Иначе
		Если НЕ ТекущаяНастройка.Прочее = Неопределено Тогда
			мНастройка = ТекущаяНастройка.Прочее;
		КонецЕсли;
	КонецЕсли;
	
	РеквизитыДляСохранения = Неопределено;

	Для каждого РеквизитНастройки из мНастройка Цикл
		Значение = мНастройка[РеквизитНастройки.Ключ];
		Выполнить(Строка(РеквизитНастройки.Ключ) + " = Значение;");
	КонецЦикла;
	
	Если РеквизитыДляСохранения <> Неопределено И РеквизитыДляСохранения.Количество() Тогда
		ЗагрузитьРеквизитыИзМассива(РеквизитыДляСохранения);
	КонецЕсли;

КонецПроцедуры //вЗагрузитьНастройку()

// Устанавливает значение реквизита "ТекущаяНастройка" по имени настройки или произвольно.
//
// Параметры:
//  ИмяНастройки   - произвольное имя настройки, которое необходимо установить.
//
&НаКлиенте
Процедура УстановитьИмяНастройки(ИмяНастройки = "") Экспорт

	Если ПустаяСтрока(ИмяНастройки) Тогда
		Если ТекущаяНастройка = Неопределено Тогда
			ТекущаяНастройкаПредставление = "";
		Иначе
			ТекущаяНастройкаПредставление = ТекущаяНастройка.Обработка;
		КонецЕсли;
	Иначе
		ТекущаяНастройкаПредставление = ИмяНастройки;
	КонецЕсли;

КонецПроцедуры // вУстановитьИмяНастройки()

// Получает структуру для индикации прогресса цикла.
//
// Параметры:
//  КоличествоПроходов – Число - максимальное значение счетчика;
//  ПредставлениеПроцесса – Строка, "Выполнено" – отображаемое название процесса;
//  ВнутреннийСчетчик - Булево, *Истина - использовать внутренний счетчик с начальным значением 1,
//                    иначе нужно будет передавать значение счетчика при каждом вызове обновления индикатора;
//  КоличествоОбновлений - Число, *100 - всего количество обновлений индикатора;
//  ЛиВыводитьВремя - Булево, *Истина - выводить приблизительное время до окончания процесса;
//  РазрешитьПрерывание - Булево, *Истина - разрешает пользователю прерывать процесс.
//
// Возвращаемое значение:
//  Структура - которую потом нужно будет передавать в метод ЛксОбработатьИндикатор.
//
&НаКлиенте
Функция ПолучитьИндикаторПроцесса(КоличествоПроходов, ПредставлениеПроцесса = "Выполнено", ВнутреннийСчетчик = Истина,
	КоличествоОбновлений = 100, ЛиВыводитьВремя = Истина, РазрешитьПрерывание = Истина) Экспорт 
	
	Индикатор = Новый Структура;
	Индикатор.Вставить("КоличествоПроходов", КоличествоПроходов);
	Индикатор.Вставить("ДатаНачалаПроцесса", ТекущаяДата());
	Индикатор.Вставить("ПредставлениеПроцесса", ПредставлениеПроцесса);
	Индикатор.Вставить("ЛиВыводитьВремя", ЛиВыводитьВремя);
	Индикатор.Вставить("РазрешитьПрерывание", РазрешитьПрерывание);
	Индикатор.Вставить("ВнутреннийСчетчик", ВнутреннийСчетчик);
	Индикатор.Вставить("Шаг", КоличествоПроходов / КоличествоОбновлений);
	Индикатор.Вставить("СледующийСчетчик", 0);
	Индикатор.Вставить("Счетчик", 0);
	Возврат Индикатор;
	
КонецФункции // ЛксПолучитьИндикаторПроцесса()

// Проверяет и обновляет индикатор. Нужно вызывать на каждом проходе индицируемого цикла.
//
// Параметры:
//  Индикатор    – Структура – индикатора, полученная методом ЛксПолучитьИндикаторПроцесса;
//  Счетчик      – Число – внешний счетчик цикла, используется при ВнутреннийСчетчик = Ложь.
//
&НаКлиенте
Процедура ОбработатьИндикатор(Индикатор, Счетчик = 0) Экспорт 
	
	Если Индикатор.ВнутреннийСчетчик Тогда
		Индикатор.Счетчик = Индикатор.Счетчик + 1;
		Счетчик = Индикатор.Счетчик;
	КонецЕсли;
	Если Индикатор.РазрешитьПрерывание Тогда
		ОбработкаПрерыванияПользователя();
	КонецЕсли;
	
	Если Счетчик > Индикатор.СледующийСчетчик Тогда
		Индикатор.СледующийСчетчик = Цел(Счетчик + Индикатор.Шаг);
		Если Индикатор.ЛиВыводитьВремя Тогда
			ПрошлоВремени = ТекущаяДата() - Индикатор.ДатаНачалаПроцесса;
			Осталось = ПрошлоВремени * (Индикатор.КоличествоПроходов / Счетчик - 1);
			Часов = Цел(Осталось / 3600);
			Осталось = Осталось - (Часов * 3600);
			Минут = Цел(Осталось / 60);
			Секунд = Цел(Цел(Осталось - (Минут * 60)));
			ОсталосьВремени = Формат(Часов, "ЧЦ=2; ЧН=00; ЧВН=") + ":" 
			+ Формат(Минут, "ЧЦ=2; ЧН=00; ЧВН=") + ":" 
			+ Формат(Секунд, "ЧЦ=2; ЧН=00; ЧВН=");
			ТекстОсталось = "Осталось: ~" + ОсталосьВремени;
		Иначе
			ТекстОсталось = "";
		КонецЕсли;
		
		Если Индикатор.КоличествоПроходов > 0 Тогда
			ТекстСостояния = ТекстОсталось;
		Иначе
			ТекстСостояния = "";
		КонецЕсли;
		
		Состояние(Индикатор.ПредставлениеПроцесса, Счетчик / Индикатор.КоличествоПроходов * 100, ТекстСостояния);
	КонецЕсли;
	
	Если Счетчик = Индикатор.КоличествоПроходов Тогда
		Состояние(Индикатор.ПредставлениеПроцесса, 100, ТекстСостояния);
	КонецЕсли;
	
КонецПроцедуры // ЛксОбработатьИндикатор()

// Загружает справочник.
//
// Параметры: 
//  Объект         - объект справочник.
//
&НаСервере
Процедура ЗагрузитьСправочник(Объект)

	// Код
	Если Объект.ДлинаКода Тогда
		НоваяСтрока = Реквизиты.Добавить();
		НоваяСтрока.Реквизит      = "Код";
		НоваяСтрока.Идентификатор = "Код";
		Если Объект.ТипКода = Метаданные.СвойстваОбъектов.ТипКодаСправочника.Число Тогда
			НоваяСтрока.Тип = ОписаниеТипа("Число");
		ИначеЕсли Объект.ТипКода = Метаданные.СвойстваОбъектов.ТипКодаСправочника.Строка Тогда
			НоваяСтрока.Тип = ОписаниеТипа("Строка");
		КонецЕсли;
		НоваяСтрока.Значение = НоваяСтрока.Тип.ПривестиЗначение();
	КонецЕсли;

	// Наименование
	Если Объект.ДлинаНаименования Тогда
		НоваяСтрока = Реквизиты.Добавить();
		НоваяСтрока.Реквизит      = "Наименование";
		НоваяСтрока.Идентификатор = "Наименование";
		НоваяСтрока.Тип           = ОписаниеТипа("Строка");
		НоваяСтрока.Значение      = НоваяСтрока.Тип.ПривестиЗначение();
	КонецЕсли;
	
	мМенеджеры = РеквизитФормыВЗначение("ОбъектОбработки").мМенеджеры;

	// Владелец
	Если Объект.Владельцы.Количество() Тогда
		НоваяСтрока = Реквизиты.Добавить();
		НоваяСтрока.Реквизит      = "Владелец";
		НоваяСтрока.Идентификатор = "Владелец";
		
		МассивТипов = Новый Массив;
		Для каждого Владелец из Объект.Владельцы Цикл
			МассивТипов.Добавить(мМенеджеры[Владелец].ТипСсылки);
		КонецЦикла;
		НоваяСтрока.Тип = Новый ОписаниеТипов(МассивТипов);
		НоваяСтрока.Значение = НоваяСтрока.Тип.ПривестиЗначение();
	КонецЕсли;

	// Родитель
	Если Объект.КоличествоУровней > 1 Тогда
		НоваяСтрока = Реквизиты.Добавить();
		НоваяСтрока.Реквизит      = "Родитель";
		НоваяСтрока.Идентификатор = "Родитель";


		МассивТипов = Новый Массив;
		МассивТипов.Добавить(мМенеджеры[Объект].ТипСсылки);

		НоваяСтрока.Тип = Новый ОписаниеТипов(МассивТипов);
		НоваяСтрока.Значение = НоваяСтрока.Тип.ПривестиЗначение();
	КонецЕсли;

	ЗагрузитьРеквизиты(Объект);

КонецПроцедуры // ЗагрузитьСправочник()

// Загружает документ.
//
// Параметры: 
//  Объект         - объект документ.
//
&НаСервере
Процедура ЗагрузитьДокумент(Объект)

	// Номер
	Если Объект.ДлинаНомера Тогда
		НоваяСтрока = Реквизиты.Добавить();
		НоваяСтрока.Реквизит      = "Номер";
		НоваяСтрока.Идентификатор = "Номер";
		Если Объект.ТипНомера = Метаданные.СвойстваОбъектов.ТипНомераДокумента.Число Тогда
			НоваяСтрока.Тип = ОписаниеТипа("Число");
		ИначеЕсли Объект.ТипНомера = Метаданные.СвойстваОбъектов.ТипНомераДокумента.Строка Тогда
			НоваяСтрока.Тип = ОписаниеТипа("Строка");
		КонецЕсли;
		НоваяСтрока.Значение = НоваяСтрока.Тип.ПривестиЗначение();
	КонецЕсли;

	// Дата
	НоваяСтрока = Реквизиты.Добавить();
	НоваяСтрока.Реквизит      = "Дата";
	НоваяСтрока.Идентификатор = "Дата";
	НоваяСтрока.Тип           = ОписаниеТипа("Дата");
	НоваяСтрока.Значение      = НоваяСтрока.Тип.ПривестиЗначение();

	ЗагрузитьРеквизиты(Объект);

КонецПроцедуры // ЗагрузитьДокумент()

// Загружает реквизиты справочника или документа.
//
// Параметры: 
//  Объект         - объект справочник или документ.
//
&НаСервере
Процедура ЗагрузитьРеквизиты(Объект)

	Для каждого Реквизит из Объект.Реквизиты Цикл
		Если Реквизит.Тип.Типы().Количество() = 1 Тогда
			Если Реквизит.Тип.СодержитТип(Тип("ХранилищеЗначения")) Тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		НоваяСтрока = Реквизиты.Добавить();
		НоваяСтрока.Реквизит      = ?(ПустаяСтрока(Реквизит.Синоним), Реквизит.Имя, Реквизит.Синоним);
		НоваяСтрока.Идентификатор = Реквизит.Имя;
		НоваяСтрока.Тип           = Реквизит.Тип;
		НоваяСтрока.Значение      = НоваяСтрока.Тип.ПривестиЗначение();
	КонецЦикла;

КонецПроцедуры // ЗагрузитьРеквизиты()

// Позволяет создать описание типов на основании строкового представления типа.
//
// Параметры: 
//  ТипСтрокой     - Строковое представление типа.
//
// Возвращаемое значение:
//  Описание типов.
//
&НаСервере
Функция ОписаниеТипа(ТипСтрокой) Экспорт

	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип(ТипСтрокой));
	ОписаниеТипов = Новый ОписаниеТипов(МассивТипов);

	Возврат ОписаниеТипов;

КонецФункции // вОписаниеТипа()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если мИспользоватьНастройки Тогда
		УстановитьИмяНастройки();
		ЗагрузитьНастройку();
	Иначе
		Элементы.ТекущаяНастройка.Доступность = Ложь;
		Элементы.СохранитьНастройки.Доступность = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("Настройка") Тогда
		ТекущаяНастройка = Параметры.Настройка;
	КонецЕсли;
	Если Параметры.Свойство("НайденныеОбъекты") Тогда
		НайденныеОбъекты.ЗагрузитьЗначения(Параметры.НайденныеОбъекты);
	КонецЕсли;
	ТекущаяСтрока = -1;
	Если Параметры.Свойство("ТекущаяСтрока") Тогда
		Если Параметры.ТекущаяСтрока <> Неопределено Тогда
			ТекущаяСтрока = Параметры.ТекущаяСтрока;
		КонецЕсли;
	КонецЕсли;
	Если Параметры.Свойство("Родитель") Тогда
		Родитель = Параметры.Родитель;
	КонецЕсли;
	
	Элементы.ТекущаяНастройка.СписокВыбора.Очистить();
	Если Параметры.Свойство("Настройки") Тогда
		Для Каждого Строка из Параметры.Настройки Цикл
			Элементы.ТекущаяНастройка.СписокВыбора.Добавить(Строка, Строка.Обработка);
		КонецЦикла;
	КонецЕсли;
	
	Если Параметры.Свойство("ОбъектПоиска") Тогда
		ОбъектПоиска = Параметры.ОбъектПоиска;
		ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ОбъектПоиска.Тип + "." + ОбъектПоиска.Имя);
		Если ОбъектПоиска.Тип = "Справочник" Тогда
			ЗагрузитьСправочник(ОбъектМетаданных);
		ИначеЕсли ОбъектПоиска.Тип = "Документ" Тогда
			ЗагрузитьДокумент(ОбъектМетаданных);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ, ВЫЗЫВАЕМЫЕ ИЗ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура ВыполнитьОбработкуКоманда(Команда)
	ОбработаноОбъектов = ВыполнитьОбработку();

	Предупреждение("Обработка <" + СокрЛП(ЭтаФорма.Заголовок) + "> завершена!
				   |Обработано объектов: " + ОбработаноОбъектов + ".")
КонецПроцедуры

&НаКлиенте
Процедура СохранитьНастройкиКоманда(Команда)
	СохранитьНастройку();
КонецПроцедуры

&НаКлиенте
Процедура ТекущаяНастройкаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;

	Если НЕ ТекущаяНастройка = ВыбранноеЗначение Тогда

		Если ЭтаФорма.Модифицированность Тогда
			Если Вопрос("Сохранить текущую настройку?", РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Да) = КодВозвратаДиалога.Да Тогда
				СохранитьНастройку();
			КонецЕсли;
		КонецЕсли;

		ТекущаяНастройка = ВыбранноеЗначение;
		УстановитьИмяНастройки();

		ЗагрузитьНастройку();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТекущаяНастройкаПриИзменении(Элемент)
	ЭтаФорма.Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВсе(Команда)
	ВыбратьЭлементы(Истина);
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьВыбор(Команда)
	ВыбратьЭлементы(Ложь);
КонецПроцедуры

&НаСервере
Процедура ВыбратьЭлементы(Выбор)
	Для Каждого Стр Из Реквизиты Цикл
		Стр.Выбрать = Выбор;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура РеквизитыЗначениеОчистка(Элемент, СтандартнаяОбработка)
	Элементы.РеквизитыЗначение.ВыбиратьТип = Истина;
КонецПроцедуры

&НаКлиенте
Процедура РеквизитыЗначениеПриИзменении(Элемент)
	Элементы.Реквизиты.ТекущиеДанные.Выбрать = Истина;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ИНИЦИАЛИЗАЦИЯ МОДУЛЬНЫХ ПЕРЕМЕННЫХ

мИспользоватьНастройки = Истина;

//Реквизиты настройки и значения по умолчанию.
мНастройка = Новый Структура("РеквизитыДляСохранения");

//мНастройка.<Имя реквизита> = <Значение реквизита>;

мТипыОбрабатываемыхОбъектов = "Справочник,Документ";