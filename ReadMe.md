[![Build Status](https://dev.azure.com/joabaj88/Test-Core-Docker-Pipeline/_apis/build/status/Todai88.CoreTesting)](https://dev.azure.com/joabaj88/Test-Core-Docker-Pipeline/_build/latest?definitionId=1)

This repo follows the structure outlined in [this blog post](https://fullstackmark.com/post/12/get-started-building-microservices-with-asp.net-core-and-docker-in-visual-studio-code), but is also heavily influenced by my experiences with microservice architecture and the eco system. Have a look at my other repositories for more information.

# Important things to note:

## Ecosystem:

### RabbitMQ:
An important rule for microservices architecture is that each microservice must own its data. In a traditional, monolithic application we often have one centralized database where we can retrieve and modify entities across the whole application often in the same process. (Like we do).

In microservices, we don't have this kind of freedom. Microservices are independent and run in their own process. So, if a change to an entity or some other notable event occurs in one microservice and must be communicated to other interested services we can use a message bus to publish and consume messages between microservices.

For this we use a broker container (rabbitmq in docker-compose.yml) and subscribe the services to it.

Here is an outline of the subscription from `/services/Jobs.Api/Startup.cs`:
```
return Bus.Factory.CreateUsingRabbitMq(sbc =>
{
    sbc.Host("rabbitmq", "/", h =>
    {
        h.Username("guest");
        h.Password("guest");
    });

    sbc.ExchangeType = ExchangeType.Fanout;
});
```
After the subscription has been established, we can publish messages like this `/services/Jobs.Api/Controllers/JobsController.cs`:
```
[HttpPost("/api/jobs/applicants")]
public async Task<IActionResult> Post([FromBody]JobApplicant model)
{
    // fetch the job data
    var job = await _jobRepository.Get(model.JobId);
    var id = await _jobRepository.AddApplicant(model);
    await _bus.Publish<ApplicantAppliedEvent>(new 
    { 
        model.JobId, 
        model.ApplicantId, 
        job.Title 
    });
    return Ok(id);
}
```

Here is a simple example on how to consume an event / message (`/services/Identity.Api/Messaging/Consumers/ApplicantAppliedEventConsumer.cs`):
```
public async Task Consume(ConsumeContext<ApplicantAppliedEvent> context)
{
    // increment the user's application count in the cache
    await _identityRepository.UpdateUserApplicationCountAsync(context.Message.ApplicantId.ToString());
}
```

Basically what you need to do is inherit from `IConsumer` and implement its functions. 

### Redis: (tba)

### Azure Container Registry

You can use keys and values from Azure's container registry (access keys) to while working with your registry with the Docker CLI. 

![Azure Container Registry - Access Keys](https://docs.microsoft.com/en-us/azure/container-registry/media/container-registry-get-started-portal/qs-portal-06.png)

To use it, you need to use `docker login` to log in to the service as such:
```
    docker login --username <username> --password <password> <login server>
```

The command returns Login Succeeded once completed. You might also see a security warning recommending the use of the --password-stdin parameter. While its use is outside the scope of this article, we recommend following this best practice. See the [docker login](https://docs.docker.com/engine/reference/commandline/login/) command reference for more information.

### Docker-compose with ACR readup:
[docker-compose](https://docs.microsoft.com/en-us/azure/devops/pipelines/languages/docker?view=vsts&tabs=yaml#use-docker-compose)