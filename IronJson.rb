$: << 'D:/Programs/Univeris/Univeris.DLL'
print $:

require 'Univeris.Storage'
#require 'Univeris.Storage.Data'
#require 'Univeris.Storage.Entities'
#
#require 'Univeris.Utils'
#require 'Univeris.Utils.Serialization'
#
#
#require 'Univeris.Data.Common'
#require 'Univeris.Data.DbAccess'
#
#require 'mscorlib'
#
#include Univeris::Utils
#include Univeris::Utils::Serialization
#
include Univeris::Storage
include Univeris::Storage::System
#include Univeris::Storage::Data
#include Univeris::Storage::Entities
#
#include Univeris::Data::Common
#include Univeris::Data::DbAccess
#
#require 'System'
#require 'System.Core'
#require 'System.Configuration'
#
#include System::Collections::Generic
include System
#include System::Configuration
#include System::Core
#include System::Data



id = Guid.Parse("795A8676-075B-47E8-B68B-F11CD32FD92B")

CONNECTION_STRING = "Data Source=.\\SQLExpress;Initial Catalog=Univeris;Integrated Security=True"
instanceSystem = SystemStorageInstance.new(CONNECTION_STRING)
session = instanceSystem.OpenSession()

#
# Вот так запускается метод .NET с generics
containers = session.method(:LoadAll).of(StorageContainer).call()

flag = false

containers.each do |container|
	#puts container.Name()
	if container.Name == "Test" then
		flag = true
	end
end
if flag == false then
	container = StorageContainer.new
	container.Name = "Test"

	session.Store(container)
	session.Commit()

	puts container.Name
end

instance = StorageInstance.new(CONNECTION_STRING, "Test")
session = instance.OpenSession()

testId = "2d931510-d99f-494a-8c67-87feb05e1594"
testGuid = Guid.Parse("2d931510-d99f-494a-8c67-87feb05e1594")

jsonString = %q{
{
        "__class" : "TestClass",
        "Id" : "2d931510-d99f-494a-8c67-87feb05e1594",
        "val1" : "MyTestClass",
}
}

begin
  session = instance.OpenSession()
  session.Store("TestClass", jsonString)

  jsonNet = session.Load("TestClass", testGuid)

  puts jsonNet

  session.Commit()
end
