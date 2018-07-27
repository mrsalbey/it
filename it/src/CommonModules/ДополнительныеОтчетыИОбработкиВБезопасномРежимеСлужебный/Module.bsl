////////////////////////////////////////////////////////////////////////////////
// Подсистема "Дополнительные отчеты и обработки", расширение безопасного режима,
// служебные процедуры и функции.
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Только для внутреннего использования.
Функция СформироватьКлючСессииРасширенияБезопасногоРежима(Знач Обработка) Экспорт
	
	Возврат Обработка.УникальныйИдентификатор();
	
КонецФункции

// Только для внутреннего использования.
Функция ПолучитьРазрешенияСессииРасширенияБезопасногоРежима(Знач КлючСессии) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	СтандартнаяОбработка = Истина;
	ОписанияРазрешений = Неопределено;
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.ДополнительныеОтчетыИОбработкиВМоделиСервиса") Тогда
		
		МодульДополнительныеОтчетыИОбработкиВБезопасномРежимеСлужебныйВМоделиСервиса = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("ДополнительныеОтчетыИОбработкиВБезопасномРежимеСлужебныйВМоделиСервиса");
		МодульДополнительныеОтчетыИОбработкиВБезопасномРежимеСлужебныйВМоделиСервиса.ПолучитьРазрешенияСессииРасширенияБезопасногоРежима(
			КлючСессии,
			ОписанияРазрешений,
			СтандартнаяОбработка);
		
	КонецЕсли;
	
	Если СтандартнаяОбработка Тогда
		
		Ссылка = Справочники.ДополнительныеОтчетыИОбработки.ПолучитьСсылку(КлючСессии);
		ТекстЗапроса =
			"ВЫБРАТЬ
			|	Разрешения.ВидРазрешения КАК ВидРазрешения,
			|	Разрешения.Параметры КАК Параметры
			|ИЗ
			|	Справочник.ДополнительныеОтчетыИОбработки.Разрешения КАК Разрешения
			|ГДЕ
			|	Разрешения.Ссылка = &Ссылка";
		Запрос = Новый Запрос(ТекстЗапроса);
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		ОписанияРазрешений = Запрос.Выполнить().Выгрузить();
		
	КонецЕсли;
	
	Результат = Новый Соответствие();
	
	Для Каждого ОписаниеРазрешения из ОписанияРазрешений Цикл
		
		ТипРазрешения = ФабрикаXDTO.Тип(
			ДополнительныеОтчетыИОбработкиВБезопасномРежимеИнтерфейс.Пакет(),
			ОписаниеРазрешения.ВидРазрешения);
		
		Результат.Вставить(ТипРазрешения, ОписаниеРазрешения.Параметры.Получить());
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Только для внутреннего использования.
Функция ВыполнитьСценарийБезопасногоРежима(Знач КлючСессии, Знач Сценарий, Знач ИсполняемыйОбъект, ПараметрыВыполнения, СохраняемыеПараметры = Неопределено, ОбъектыНазначения = Неопределено) Экспорт
	
	Исключения = ДополнительныеОтчетыИОбработкиВБезопасномРежимеПовтИсп.ПолучитьРазрешенныеМетоды();
	
	Если СохраняемыеПараметры = Неопределено Тогда
		СохраняемыеПараметры = Новый Структура();
	КонецЕсли;
	
	Для Каждого ШагСценария Из Сценарий Цикл
		
		ВыполнятьБезопасно = Истина;
		ИсполняемыйФрагмент = "";
		
		Если ШагСценария.ВидДействия = ДополнительныеОтчетыИОбработкиВБезопасномРежимеИнтерфейс.ВидДействияВызовМетодаОбработки() Тогда
			
			ИсполняемыйФрагмент = "ИсполняемыйОбъект." + ШагСценария.ИмяМетода;
			
		ИначеЕсли ШагСценария.ВидДействия = ДополнительныеОтчетыИОбработкиВБезопасномРежимеИнтерфейс.ВидДействияВызовМетодаКонфигурации() Тогда
			
			ИсполняемыйФрагмент = ШагСценария.ИмяМетода;
			
			Если Исключения.Найти(ШагСценария.ИмяМетода) <> Неопределено Тогда
				ВыполнятьБезопасно = Ложь;
			КонецЕсли;
			
		Иначе
			
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Неизвестный вид действия для этапа сценария: %1'"),
				ШагСценария.ВидДействия);
			
		КонецЕсли;
		
		НесохраняемыеПараметры = Новый Массив();
		
		ПодстрокаПараметров = "";
		
		ПараметрыМетода = ШагСценария.Параметры;
		Для Каждого ПараметрМетода Из ПараметрыМетода Цикл
			
			Если Не ПустаяСтрока(ПодстрокаПараметров) Тогда
				ПодстрокаПараметров = ПодстрокаПараметров + ", ";
			КонецЕсли;
			
			Если ПараметрМетода.Вид = ДополнительныеОтчетыИОбработкиВБезопасномРежимеИнтерфейс.ВидПараметраЗначение() Тогда
				
				НесохраняемыеПараметры.Добавить(ПараметрМетода.Значение);
				ПодстрокаПараметров = ПодстрокаПараметров + "НесохраняемыеПараметры.Получить(" +
					НесохраняемыеПараметры.ВГраница() + ")";
				
			ИначеЕсли ПараметрМетода.Вид = ДополнительныеОтчетыИОбработкиВБезопасномРежимеИнтерфейс.ВидПараметраКлючСессии() Тогда
				
				ПодстрокаПараметров = ПодстрокаПараметров + "КлючСессии";
				
			ИначеЕсли ПараметрМетода.Вид = ДополнительныеОтчетыИОбработкиВБезопасномРежимеИнтерфейс.ВидПараметраКоллекцияСохраняемыхЗначений() Тогда
				
				ПодстрокаПараметров = ПодстрокаПараметров + "СохраняемыеПараметры";
				
			ИначеЕсли ПараметрМетода.Вид = ДополнительныеОтчетыИОбработкиВБезопасномРежимеИнтерфейс.ВидПараметраСохраняемоеЗначение() Тогда
				
				ПодстрокаПараметров = ПодстрокаПараметров + "СохраняемыеПараметры." + ПараметрМетода.Значение;
				
			ИначеЕсли ПараметрМетода.Вид = ДополнительныеОтчетыИОбработкиВБезопасномРежимеИнтерфейс.ВидПараметраОбъектыНазначения() Тогда
				
				ПодстрокаПараметров = ПодстрокаПараметров + "ОбъектыНазначения";
				
			ИначеЕсли ПараметрМетода.Вид = ДополнительныеОтчетыИОбработкиВБезопасномРежимеИнтерфейс.ВидПараметраПараметрВыполненияКоманды() Тогда
				
				ПодстрокаПараметров = ПодстрокаПараметров + "ПараметрыВыполнения." + ПараметрМетода.Значение;
				
			Иначе
				
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Неизвестный параметр для этапа сценария: %1'"),
					ПараметрМетода.Вид);
				
			КонецЕсли;
			
		КонецЦикла;
		
		ИсполняемыйФрагмент = ИсполняемыйФрагмент + "(" + ПодстрокаПараметров + ")";
		
		Если ВыполнятьБезопасно <> БезопасныйРежим() Тогда
			УстановитьБезопасныйРежим(ВыполнятьБезопасно);
		КонецЕсли;
		
		Если Не ПустаяСтрока(ШагСценария.СохранениеРезультата) Тогда
			Результат = Вычислить(ИсполняемыйФрагмент);
			СохраняемыеПараметры.Вставить(ШагСценария.СохранениеРезультата, Результат);
		Иначе
			Выполнить(ИсполняемыйФрагмент);
		КонецЕсли;
		
	КонецЦикла;
	
КонецФункции

// Только для внутреннего использования.
Процедура ПроверитьЛегитимностьВыполненияОперации(Знач КлючСессии, Знач Разрешение) Экспорт
	
	ТипТребуемогоРазрешения = Разрешение.Тип();
	
	РазрешенияСессии = ПолучитьРазрешенияСессииРасширенияБезопасногоРежима(КлючСессии);
	ОграниченияРазрешения = РазрешенияСессии.Получить(ТипТребуемогоРазрешения);
	
	Если ОграниченияРазрешения = Неопределено Тогда
		
		ВызватьИсключение ТекстИсключенияРазрешениеНеПредоставлено(
			КлючСессии, ТипТребуемогоРазрешения);
		
	Иначе
		
		ПроверяемыеОграничения = ТипТребуемогоРазрешения.Свойства;
		Для Каждого ПроверяемоеОграничение Из ПроверяемыеОграничения Цикл
			
			ЗначениеОграничения = Неопределено;
			Если ОграниченияРазрешения.Свойство(ПроверяемоеОграничение.ЛокальноеИмя, ЗначениеОграничения) Тогда
				
				Если ЗначениеЗаполнено(ЗначениеОграничения) Тогда
					
					Ограничитель = Разрешение.ПолучитьXDTO(ПроверяемоеОграничение);
					
					Если ЗначениеОграничения <> Ограничитель.Значение Тогда
						
						ВызватьИсключение ТекстИсключенияРазрешениеНеПредоставленоДляОграничителя(
							КлючСессии, ТипТребуемогоРазрешения, ПроверяемоеОграничение, Ограничитель.Значение);
						
					КонецЕсли;
					
				КонецЕсли;
				
			Иначе
				
				Если Не ПроверяемоеОграничение.ВозможноПустое Тогда
					
					ВызватьИсключение ТекстИсключенияНеУстановленОбязательныйОграничитель(
						КлючСессии, ТипТребуемогоРазрешения, ПроверяемоеОграничение);
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

// Для внутреннего использования
Функция ПолучитьФайлИзВременногоХранилища(Знач АдресДвоичныхДанных) Экспорт
	
	ВременныйФайл = ПолучитьИмяВременногоФайла();
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресДвоичныхДанных);
	ДвоичныеДанные.Записать(ВременныйФайл);
	Возврат ВременныйФайл;
	
КонецФункции

// Только для внутреннего использования.
Функция ПроверитьКорректностьВызоваПоОкружению() Экспорт
	
	Возврат Не БезопасныйРежим();
	
КонецФункции

// Только для внутреннего использования.
Функция СформироватьПредставлениеРазрешений(Знач Разрешения) Экспорт
	
	ОписанияРазрешений = ДополнительныеОтчетыИОбработкиВБезопасномРежимеПовтИсп.Словарь();
	
	Результат = "<HTML><BODY bgColor=#fcfaeb>";
	
	Для Каждого Разрешение Из Разрешения Цикл
		
		ВидРазрешения = Разрешение.ВидРазрешения;
		
		ОписаниеРазрешения = ОписанияРазрешений.Получить(
			ФабрикаXDTO.Тип(
				ДополнительныеОтчетыИОбработкиВБезопасномРежимеИнтерфейс.Пакет(),
				ВидРазрешения));
		
		ПредставлениеРазрешения = ОписаниеРазрешения.Представление;
		
		ПредставлениеПараметров = "";
		Параметры = Разрешение.Параметры.Получить();
		
		Если Параметры <> Неопределено Тогда
			
			Для Каждого Параметр Из Параметры Цикл
				
				Если Не ПустаяСтрока(ПредставлениеПараметров) Тогда
					ПредставлениеПараметров = ПредставлениеПараметров + ", ";
				КонецЕсли;
				
				ПредставлениеПараметров = ПредставлениеПараметров + Строка(Параметр.Значение);
				
			КонецЦикла;
			
		КонецЕсли;
		
		Если Не ПустаяСтрока(ПредставлениеПараметров) Тогда
			ПредставлениеРазрешения = ПредставлениеРазрешения + " (" + ПредставлениеПараметров + ")";
		КонецЕсли;
		
		Результат = Результат + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			"<LI><FONT size=2>%1 <A href=""%2"">%3</A></FONT>",
			ПредставлениеРазрешения,
			"internal:" + ВидРазрешения,
			НСтр("ru = 'Подробнее...'"));
		
	КонецЦикла;
	
	Результат = Результат + "</LI></BODY></HTML>";
	
	Возврат Результат;
	
КонецФункции

// Только для внутреннего использования.
Функция СформироватьПодробноеОписаниеРазрешения(Знач ВидРазрешения, Знач ПараметрыРазрешения) Экспорт
	
	ОписанияРазрешений = ДополнительныеОтчетыИОбработкиВБезопасномРежимеПовтИсп.Словарь();
	
	Результат = "<HTML><BODY bgColor=#fcfaeb>";
	
	ОписаниеРазрешения = ОписанияРазрешений.Получить(
		ФабрикаXDTO.Тип(
			ДополнительныеОтчетыИОбработкиВБезопасномРежимеИнтерфейс.Пакет(),
			ВидРазрешения));
	
	ПредставлениеРазрешения = ОписаниеРазрешения.Представление;
	РасшифровкаРазрешения = ОписаниеРазрешения.Описание;
	
	ОписанияПараметров = Неопределено;
	ЕстьПараметры = ОписаниеРазрешения.Свойство("Параметры", ОписанияПараметров);
	
	Результат = Результат + "<P><FONT size=2><A href=""internal:home"">&lt;&lt; Назад к списку разрешений</A></FONT></P>";
	
	Результат = Результат + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		"<P><STRONG><FONT size=4>%1</FONT></STRONG></P>",
		ПредставлениеРазрешения);
	
	Результат = Результат + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		"<P><FONT size=2>%1%2</FONT></P>", РасшифровкаРазрешения, ?(
			ЕстьПараметры,
			НСтр("ru = ' со следующими ограничениями:'"),
			"."));
	
	Если ЕстьПараметры Тогда
		
		Результат = Результат + "<UL>";
		
		Для Каждого Параметр Из ОписанияПараметров Цикл
			
			ИмяПараметра = Параметр.Имя;
			ЗначениеПараметра = ПараметрыРазрешения[ИмяПараметра];
			
			Если ЗначениеЗаполнено(ЗначениеПараметра) Тогда
				
				ОписаниеПараметра = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					Параметр.Описание, ЗначениеПараметра);
				
			Иначе
				
				ОписаниеПараметра = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					"<B>%1</B>", Параметр.ОписаниеЛюбогоЗначения);
				
			КонецЕсли;
			
			Результат = Результат + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				"<LI><FONT size=2>%1</FONT>", ОписаниеПараметра);
			
		КонецЦикла;
		
		Результат = Результат + "</LI></UL>";
		
	КонецЕсли;
	
	ОписаниеПоследствий = "";
	Если ОписаниеРазрешения.Свойство("Последствия", ОписаниеПоследствий) Тогда
	
		
		Результат = Результат + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			"<P><FONT size=2><EM>%1</EM></FONT></P>",
			ОписаниеПоследствий);
		
	КонецЕсли;
	
	Результат = Результат + "<P><FONT size=2><A href=""internal:home"">&lt;&lt; Назад к списку разрешений</A></FONT></P>";
	
	Результат = Результат + "</BODY></HTML>";
	
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Только для внутреннего использования.
Функция ТекстИсключенияРазрешениеНеПредоставлено(Знач КлючСессии, Знач ТипТребуемогоРазрешения)
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Дополнительному отчету или обработке %1 не предоставлено разрешение {%2}%3!'"),
			Строка(КлючСессии), ТипТребуемогоРазрешения.URIПространстваИмен, ТипТребуемогоРазрешения.Имя);
	
КонецФункции

// Только для внутреннего использования.
Функция ТекстИсключенияРазрешениеНеПредоставленоДляОграничителя(Знач КлючСессии, Знач ТипТребуемогоРазрешения, Знач ПроверяемоеОграничение, Знач Ограничитель)
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Для дополнительного отчета или обработки %1
              |не предоставлено разрешение {%2}%3 при значении
              |ограничителя %4 равном %5!'"),
		Строка(КлючСессии), ТипТребуемогоРазрешения.URIПространстваИмен, ТипТребуемогоРазрешения.Имя,
		ПроверяемоеОграничение.ЛокальноеИмя, Ограничитель);
	
КонецФункции

// Только для внутреннего использования.
Функция ТекстИсключенияНеУстановленОбязательныйОграничитель(Знач КлючСессии, Знач ТипТребуемогоРазрешения, Знач ПроверяемоеОграничение)
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Для дополнительного отчета или обработки %1
              |при предоставлении разрешения {%2}%3 не был указан обязательный ограничитель %4!'"),
		Строка(КлючСессии), ТипТребуемогоРазрешения.URIПространстваИмен, ТипТребуемогоРазрешения.Имя,
		ПроверяемоеОграничение.ЛокальноеИмя);
	
КонецФункции

