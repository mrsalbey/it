////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// Для нового объекта выполняем код инициализации формы в ПриСозданииНаСервере.
	// Для существующего - в ПриЧтенииНаСервере.
	Если Объект.Ссылка.Пустая() Тогда
		ИнициализацияФормы();
	КонецЕсли;
	
	ТекущийПользователь = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	КомандыРаботыСБизнесПроцессамиКлиент.ОбновитьДоступностьКомандПринятияКИсполнению(ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ВыполнитьЗадачу = Ложь;
	Если НЕ (ПараметрыЗаписи.Свойство("ВыполнитьЗадачу", ВыполнитьЗадачу) И ВыполнитьЗадачу) Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗаданиеВыполнено И НЕ ЗаданиеПодтверждено 
		И НЕ ЗначениеЗаполнено(ТекущийОбъект.РезультатВыполнения) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Укажите причину, по которой задача возвращается на доработку.'"),,
			"Объект.РезультатВыполнения",,
			Отказ);
		Возврат;
	ИначеЕсли НЕ ЗаданиеВыполнено И ЗаданиеПодтверждено 
		И НЕ ЗначениеЗаполнено(ТекущийОбъект.РезультатВыполнения) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Укажите причину, по которой задача отменяется.'"),,
			"Объект.РезультатВыполнения",,
			Отказ);		
		Возврат;
	КонецЕсли;
	
	ЗаписатьРеквизитыБизнесПроцесса(ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ИнициализацияФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	БизнесПроцессыИЗадачиКлиент.ФормаЗадачиОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр, Источник);
	
	Если ИмяСобытия = "Запись_Задание" Тогда
		Если (Источник = ЗаданиеСсылка ИЛИ (ТипЗнч(Источник) = Тип("Массив") 
			И Источник.Найти(ЗаданиеСсылка) <> Неопределено)) Тогда
			Прочитать();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура СрокНачалаИсполненияПриИзменении(Элемент)
	
	Если Объект.ДатаНачала = НачалоДня(Объект.ДатаНачала) Тогда
		Объект.ДатаНачала = КонецДня(Объект.ДатаНачала);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметНажатие(Элемент, СтандартнаяОбработка)
	Если ТипЗнч(Объект.Предмет) = Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда
		БизнесПроцессыИЗадачиКлиент.ОткрытьФормуВыполненияЗадачи(Объект.Предмет);
	Иначе	
		ОткрытьЗначение(Объект.Предмет);
	КонецЕсли;
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить(Команда)
	
	БизнесПроцессыИЗадачиКлиент.ЗаписатьИЗакрытьВыполнить(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Выполнено(Команда)
	
	ЗаданиеПодтверждено = Истина;
	ЗаданиеВыполнено = Истина;
	БизнесПроцессыИЗадачиКлиент.ЗаписатьИЗакрытьВыполнить(ЭтаФорма, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Возвращено(Команда)
	
	ЗаданиеПодтверждено = Ложь;
	ЗаданиеВыполнено = Ложь;
	БизнесПроцессыИЗадачиКлиент.ЗаписатьИЗакрытьВыполнить(ЭтаФорма, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Отменено(Команда)
	
	ЗаданиеПодтверждено = Истина;
	ЗаданиеВыполнено = Ложь;
	БизнесПроцессыИЗадачиКлиент.ЗаписатьИЗакрытьВыполнить(ЭтаФорма, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьЗаданиеВыполнить(Команда)
	
	Записать();
	ОткрытьЗначение(ЗаданиеСсылка);
	
КонецПроцедуры

&НаКлиенте
Процедура Дополнительно(Команда)
	
	БизнесПроцессыИЗадачиКлиент.ОткрытьДопИнформациюОЗадаче(Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПринятьКИсполнению(Команда)
	
	КомандыРаботыСБизнесПроцессамиКлиент.ПринятьЗадачуКИсполнению(ЭтаФорма, ТекущийПользователь);	
	
КонецПроцедуры
                                                        
&НаКлиенте
Процедура ОтменитьПринятиеКИсполнению(Команда)
	
	КомандыРаботыСБизнесПроцессамиКлиент.ОтменитьПринятиеЗадачиКИсполнению(ЭтаФорма);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ИнициализацияФормы()
	
	НачальныйПризнакВыполнения = Объект.Выполнена;
	ПрочитатьРеквизитыБизнесПроцесса();
	УстановитьСостояниеЭлементов();
	
	ИспользоватьДатуИВремяВСрокахЗадач = ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач");
	Элементы.СрокНачалаИсполненияВремя.Видимость = ИспользоватьДатуИВремяВСрокахЗадач;
	Элементы.ДатаИсполненияВремя.Видимость = ИспользоватьДатуИВремяВСрокахЗадач;
	БизнесПроцессыИЗадачиСервер.УстановитьФорматДаты(Элементы.СрокИсполнения);
	БизнесПроцессыИЗадачиСервер.УстановитьФорматДаты(Элементы.Дата);
	
	БизнесПроцессыИЗадачиСервер.ФормаЗадачиПриСозданииНаСервере(ЭтаФорма, Объект, 
		Элементы.ГруппаСостояние, Элементы.ДатаИсполнения);
	Элементы.ОписаниеРезультата.ТолькоПросмотр = Объект.Выполнена;
	
КонецПроцедуры	

&НаСервере
Процедура ПрочитатьРеквизитыБизнесПроцесса()
	
	ЗадачаОбъект = РеквизитФормыВЗначение("Объект");
	
	УстановитьПривилегированныйРежим(Истина);
	ЗаданиеОбъект = ЗадачаОбъект.БизнесПроцесс.ПолучитьОбъект();
	ЗаданиеВыполнено = ЗаданиеОбъект.Выполнено;
	ЗаданиеСсылка = ЗаданиеОбъект.Ссылка;
	ЗаданиеПодтверждено = ЗаданиеОбъект.Подтверждено;
	ЗаданиеРезультатВыполнения = ЗаданиеОбъект.РезультатВыполнения;
	ЗаданиеСодержание = ЗаданиеОбъект.Содержание;
	
КонецПроцедуры	

&НаСервере
Процедура ЗаписатьРеквизитыБизнесПроцесса(ЗадачаОбъект)
	
	УстановитьПривилегированныйРежим(Истина);
	ЗаданиеОбъект = ЗадачаОбъект.БизнесПроцесс.ПолучитьОбъект();
	ЗаблокироватьДанныеДляРедактирования(ЗаданиеОбъект.Ссылка);
	ЗаданиеОбъект.Выполнено = ЗаданиеВыполнено;
	ЗаданиеОбъект.Подтверждено = ЗаданиеПодтверждено;
	ЗаданиеОбъект.Записать();

КонецПроцедуры	

&НаСервере
Процедура УстановитьСостояниеЭлементов()
	
	БизнесПроцессы.Задание.УстановитьСостояниеЭлементовФормыЗадачи(ЭтаФорма);
	
КонецПроцедуры	
