using NUnit.Framework;

namespace DTValidator 
{
	public class ValidationTests 
	{
		[Test]
		public void ValidateSavedScriptableObjects() 
		{
			var errors = ValidationUtil.ValidateAllSavedScriptableObjects(earlyExitOnError: true);
			
			Assert.That(errors, Is.Empty);
		}

		[Test]
		public void ValidateGameObjectsInResources() 
		{
			var errors = ValidationUtil.ValidateAllGameObjectsInResources(earlyExitOnError: true);
			
			Assert.That(errors, Is.Empty);
		}

		[Test]
		public void ValidateSavedScenes() 
		{
			var errors = ValidationUtil.ValidateAllGameObjectsInSavedScenes(earlyExitOnError: true);
			
			Assert.That(errors, Is.Empty);
		}

		[Test]
		public void ValidateBuildScenes() 
		{
			var errors = ValidationUtil.ValidateAllGameObjectsInBuildSettingScenes(earlyExitOnError: true);
			
			Assert.That(errors, Is.Empty);
		}
	}
}
